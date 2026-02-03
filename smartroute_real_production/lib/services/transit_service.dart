import '../models/transit.dart';
import '../models/place.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/logger.dart';

class TransitService {
  static final TransitService _instance = TransitService._internal();
  factory TransitService() => _instance;
  TransitService._internal();

  static const String _baseUrl = 'https://api.odsay.com/v1/api';
  static const String _apiKey = 'Jsab5cqnbqag4GwNtQTRi/kD7zyKsYdZQGYMaioDl+4';

  Future<List<TransitRoute>> searchRoutes(
    Place from,
    Place to,
    DateTime departureTime,
  ) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/searchPubTransPathT'
        '?SX=${from.lng}'
        '&SY=${from.lat}'
        '&EX=${to.lng}'
        '&EY=${to.lat}'
        '&apiKey=$_apiKey',
      );

      AppLogger.info('ODsay API 경로 검색: ${from.name} → ${to.name}');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['error'] != null) {
          final errorMsg = data['error']['msg'] ?? '경로 검색 실패';
          AppLogger.error('ODsay API 에러: $errorMsg');
          throw Exception(errorMsg);
        }

        final result = data['result'];
        if (result == null || result['path'] == null) {
          AppLogger.warning('경로를 찾을 수 없습니다');
          return _getDummyRoutes(departureTime); // 폴백
        }

        final List paths = result['path'];
        
        return paths.asMap().entries.map((entry) {
          final index = entry.key;
          final path = entry.value;
          final info = path['info'];
          final subPath = path['subPath'] as List? ?? [];

          // 경로 이름 생성
          String routeName = '경로 ${index + 1}';
          if (index == 0) routeName = '빠른 경로';
          if (info['busTransitCount'] == 0 && info['subwayTransitCount'] > 0) {
            routeName = '지하철 직행';
          } else if (info['busTransitCount'] > 0 && info['subwayTransitCount'] == 0) {
            routeName = '버스 직행';
          }

          final totalTime = info['totalTime'] ?? 0;

          return TransitRoute(
            id: 'odsay_route_${DateTime.now().millisecondsSinceEpoch}_$index',
            name: routeName,
            totalDurationMin: totalTime,
            transferCount: (info['busTransitCount'] ?? 0) + (info['subwayTransitCount'] ?? 0),
            totalFare: info['payment'] ?? 0,
            steps: subPath.map((step) => _parseTransitStep(step)).toList(),
            departureTime: departureTime,
            arrivalTime: departureTime.add(Duration(minutes: totalTime)),
          );
        }).toList();
      } else {
        AppLogger.error('ODsay API 실패: ${response.statusCode}');
        return _getDummyRoutes(departureTime); // 폴백
      }
    } catch (e) {
      AppLogger.error('경로 검색 에러', error: e);
      return _getDummyRoutes(departureTime); // 폴백
    }
  }

  TransitStep _parseTransitStep(Map<String, dynamic> step) {
    final trafficType = step['trafficType'];
    TransitType type = TransitType.walk;
    String lineName = '';
    String lineColor = '#999999';
    String fromStation = step['startName'] ?? '';
    String endStation = step['endName'] ?? '';
    int fare = step['payment'] ?? 0;

    switch (trafficType) {
      case 1: // 지하철
        type = TransitType.subway;
        final lane = step['lane'];
        if (lane != null && lane.isNotEmpty) {
          lineName = lane[0]['name'] ?? '';
          // 노선별 색상
          lineColor = _getSubwayColor(lineName);
        }
        break;
      case 2: // 버스
        type = TransitType.bus;
        final lane = step['lane'];
        if (lane != null && lane.isNotEmpty) {
          lineName = lane[0]['name'] ?? '';
          final busType = lane[0]['type'] ?? 0;
          lineColor = _getBusColor(busType);
        }
        break;
      case 3: // 도보
        type = TransitType.walk;
        lineName = '도보';
        fromStation = step['startName'] ?? '출발';
        endStation = step['endName'] ?? '도착';
        break;
    }

    return TransitStep(
      id: 'step_${DateTime.now().millisecondsSinceEpoch}_${step.hashCode}',
      type: type,
      lineName: lineName,
      lineColor: lineColor,
      fromStation: fromStation,
      toStation: endStation,
      stationCount: step['stationCount'] ?? 0,
      durationMin: step['sectionTime'] ?? 0,
      fare: fare,
    );
  }

  String _getSubwayColor(String lineName) {
    if (lineName.contains('1호선')) return '#0052A4';
    if (lineName.contains('2호선')) return '#00A84D';
    if (lineName.contains('3호선')) return '#EF7C1C';
    if (lineName.contains('4호선')) return '#00A5DE';
    if (lineName.contains('5호선')) return '#996CAC';
    if (lineName.contains('6호선')) return '#CD7C2F';
    if (lineName.contains('7호선')) return '#747F00';
    if (lineName.contains('8호선')) return '#E6186C';
    if (lineName.contains('9호선')) return '#BDB092';
    if (lineName.contains('경의중앙선')) return '#77C4A3';
    if (lineName.contains('분당선')) return '#FABE00';
    return '#999999';
  }

  String _getBusColor(int busType) {
    switch (busType) {
      case 1: return '#6B4EA3'; // 공항
      case 2: return '#6EBF46'; // 마을
      case 3: return '#3D5AFE'; // 간선
      case 4: return '#5BB025'; // 지선
      case 5: return '#F99D1C'; // 순환
      case 6: return '#E60012'; // 광역
      default: return '#3D5AFE';
    }
  }

  // 폴백용 더미 데이터
  List<TransitRoute> _getDummyRoutes(DateTime departureTime) {
    return [
      TransitRoute(
        id: 'route_1',
        name: '빠른 경로',
        totalDurationMin: 45,
        totalFare: 1400,
        transferCount: 1,
        steps: [
          const TransitStep(
            id: 'step_1',
            type: TransitType.subway,
            lineName: '2호선',
            lineColor: '#00A84D',
            fromStation: '역삼역',
            toStation: '강남역',
            durationMin: 25,
            stationCount: 3,
            fare: 700,
          ),
          const TransitStep(
            id: 'step_2',
            type: TransitType.bus,
            lineName: '146',
            lineColor: '#3D5AFE',
            fromStation: '강남역',
            toStation: '도착지',
            durationMin: 20,
            stationCount: 5,
            fare: 700,
          ),
        ],
        departureTime: departureTime,
        arrivalTime: departureTime.add(const Duration(minutes: 45)),
      ),
    ];
  }
}
