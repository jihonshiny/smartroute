import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transit_route.dart';
import '../utils/logger.dart';

class OdsayApiService {
  static const String _baseUrl = 'https://api.odsay.com/v1/api';
  static const String _apiKey = 'Jsab5cqnbqag4GwNtQTRi/kD7zyKsYdZQGYMaioDl+4';

  /// 대중교통 경로 검색
  /// [startLat] 출발지 위도
  /// [startLng] 출발지 경도
  /// [endLat] 도착지 위도
  /// [endLng] 도착지 경도
  Future<List<TransitRoute>> searchRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/searchPubTransPathT'
        '?SX=$startLng'
        '&SY=$startLat'
        '&EX=$endLng'
        '&EY=$endLat'
        '&apiKey=$_apiKey',
      );

      AppLogger.info('ODsay API 호출: $url');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['error'] != null) {
          AppLogger.error('ODsay API 에러: ${data['error']}');
          return [];
        }

        final result = data['result'];
        if (result == null || result['path'] == null) {
          AppLogger.warning('경로를 찾을 수 없습니다');
          return [];
        }

        final List paths = result['path'];
        
        return paths.map((path) {
          final info = path['info'];
          final subPath = path['subPath'] as List? ?? [];

          // 교통수단 정보 파싱
          final steps = subPath.map((step) {
            return TransitStep(
              type: _getTransitType(step['trafficType']),
              name: step['lane']?[0]?['name'] ?? '',
              startStation: step['startName'] ?? '',
              endStation: step['endName'] ?? '',
              stationCount: step['stationCount'] ?? 0,
              distance: (step['distance'] ?? 0).toDouble(),
              time: step['sectionTime'] ?? 0,
            );
          }).toList();

          return TransitRoute(
            totalTime: info['totalTime'] ?? 0,
            totalDistance: (info['totalDistance'] ?? 0).toDouble(),
            totalFare: info['payment'] ?? 0,
            transferCount: info['busTransitCount'] + info['subwayTransitCount'],
            steps: steps,
          );
        }).toList();
      } else {
        AppLogger.error('ODsay API 실패: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      AppLogger.error('ODsay API 에러', error: e);
      return [];
    }
  }

  String _getTransitType(int? trafficType) {
    switch (trafficType) {
      case 1: return 'subway';
      case 2: return 'bus';
      case 3: return 'walk';
      default: return 'unknown';
    }
  }

  /// 지하철 노선 정보 조회
  Future<List<SubwayLine>> getSubwayLines() async {
    // 서울 주요 지하철 노선 정보 (하드코딩)
    return [
      SubwayLine(id: '1', name: '1호선', color: '0052A4'),
      SubwayLine(id: '2', name: '2호선', color: '00A84D'),
      SubwayLine(id: '3', name: '3호선', color: 'EF7C1C'),
      SubwayLine(id: '4', name: '4호선', color: '00A5DE'),
      SubwayLine(id: '5', name: '5호선', color: '996CAC'),
      SubwayLine(id: '6', name: '6호선', color: 'CD7C2F'),
      SubwayLine(id: '7', name: '7호선', color: '747F00'),
      SubwayLine(id: '8', name: '8호선', color: 'E6186C'),
      SubwayLine(id: '9', name: '9호선', color: 'BDB092'),
    ];
  }

  /// 버스 정보 조회
  Future<BusInfo?> getBusInfo(String busNumber) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/searchBusLane'
        '?lang=0'
        '&CID=1000'
        '&BusNo=$busNumber'
        '&apiKey=$_apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['result']?['lane'] != null && data['result']['lane'].isNotEmpty) {
          final lane = data['result']['lane'][0];
          
          return BusInfo(
            name: lane['busNo'] ?? '',
            type: _getBusType(lane['type']),
            firstTime: lane['firstTime'] ?? '',
            lastTime: lane['lastTime'] ?? '',
            interval: lane['term'] ?? 0,
          );
        }
      }
      return null;
    } catch (e) {
      AppLogger.error('버스 정보 조회 실패', error: e);
      return null;
    }
  }

  String _getBusType(int? type) {
    switch (type) {
      case 1: return '공항버스';
      case 2: return '마을버스';
      case 3: return '간선버스';
      case 4: return '지선버스';
      case 5: return '순환버스';
      case 6: return '광역버스';
      case 7: return '인천버스';
      case 8: return '경기버스';
      default: return '일반버스';
    }
  }
}

// 지하철 노선 모델
class SubwayLine {
  final String id;
  final String name;
  final String color;

  SubwayLine({
    required this.id,
    required this.name,
    required this.color,
  });
}

// 버스 정보 모델
class BusInfo {
  final String name;
  final String type;
  final String firstTime;
  final String lastTime;
  final int interval;

  BusInfo({
    required this.name,
    required this.type,
    required this.firstTime,
    required this.lastTime,
    required this.interval,
  });
}
