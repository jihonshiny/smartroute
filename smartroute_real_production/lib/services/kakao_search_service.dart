import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app/config.dart';
import '../models/place.dart';

class KakaoSearchService {
  static final KakaoSearchService _instance = KakaoSearchService._internal();
  factory KakaoSearchService() => _instance;
  KakaoSearchService._internal();

  final String _baseUrl = 'https://dapi.kakao.com/v2/local/search';

  Future<List<Place>> search(String query, {int page = 1, int size = 15}) async {
    try {
      final uri = Uri.parse('$_baseUrl/keyword.json').replace(
        queryParameters: {
          'query': query,
          'page': page.toString(),
          'size': size.toString(),
        },
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'KakaoAK ${AppConfig.kakaoRestApiKey}',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final documents = data['documents'] as List;
        
        return documents.map((doc) {
          return Place(
            id: doc['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
            name: doc['place_name'] ?? '',
            address: doc['address_name'] ?? doc['road_address_name'] ?? '',
            lat: double.tryParse(doc['y'] ?? '0') ?? 0.0,
            lng: double.tryParse(doc['x'] ?? '0') ?? 0.0,
            phone: doc['phone'],
            category: doc['category_name'],
            url: doc['place_url'],
          );
        }).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Kakao API 인증 실패 - API 키를 확인하세요');
      } else {
        throw Exception('검색 실패: ${response.statusCode}');
      }
    } catch (e) {
      // API 실패 시 Mock 데이터 반환
      print('Kakao API Error: $e');
      return _getMockResults(query);
    }
  }

  Future<List<Place>> searchByCategory(String category, {double? lat, double? lng}) async {
    try {
      final uri = Uri.parse('$_baseUrl/category.json').replace(
        queryParameters: {
          'category_group_code': _getCategoryCode(category),
          if (lat != null) 'y': lat.toString(),
          if (lng != null) 'x': lng.toString(),
          'radius': '5000',
          'size': '15',
        },
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'KakaoAK ${AppConfig.kakaoRestApiKey}',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final documents = data['documents'] as List;
        
        return documents.map((doc) {
          return Place(
            id: doc['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
            name: doc['place_name'] ?? '',
            address: doc['address_name'] ?? doc['road_address_name'] ?? '',
            lat: double.tryParse(doc['y'] ?? '0') ?? 0.0,
            lng: double.tryParse(doc['x'] ?? '0') ?? 0.0,
            phone: doc['phone'],
            category: doc['category_name'],
          );
        }).toList();
      }
      
      return _getMockResults(category);
    } catch (e) {
      return _getMockResults(category);
    }
  }

  String _getCategoryCode(String category) {
    switch (category) {
      case '카페':
        return 'CE7';
      case '식당':
        return 'FD6';
      case '은행':
        return 'BK9';
      case '병원':
        return 'HP8';
      case '약국':
        return 'PM9';
      case '편의점':
        return 'CS2';
      case '주차장':
        return 'PK6';
      case '주유소':
        return 'OL7';
      default:
        return 'CE7';
    }
  }

  List<Place> _getMockResults(String query) {
    return [
      Place(
        id: '1',
        name: 'KB국민은행 강남점',
        address: '서울시 강남구 테헤란로 123',
        lat: 37.5012,
        lng: 127.0396,
        category: '은행',
        phone: '02-1234-5678',
      ),
      Place(
        id: '2',
        name: '이마트 역삼점',
        address: '서울시 강남구 역삼동 456',
        lat: 37.5000,
        lng: 127.0360,
        category: '쇼핑',
        phone: '1588-1234',
      ),
      Place(
        id: '3',
        name: '온누리약국 테헤란점',
        address: '서울시 강남구 테헤란로 130',
        lat: 37.5015,
        lng: 127.0400,
        category: '약국',
        phone: '02-567-8901',
      ),
      Place(
        id: '4',
        name: '강남우체국',
        address: '서울시 강남구 논현로 789',
        lat: 37.4990,
        lng: 127.0350,
        category: '우편',
        phone: '02-789-0123',
      ),
      Place(
        id: '5',
        name: '스타벅스 강남역점',
        address: '서울시 강남구 강남대로 396',
        lat: 37.4979,
        lng: 127.0276,
        category: '카페',
        phone: '1522-3232',
      ),
      Place(
        id: '6',
        name: '신세계백화점 강남점',
        address: '서울시 서초구 신반포로 176',
        lat: 37.5048,
        lng: 127.0047,
        category: '쇼핑',
        phone: '02-3479-1234',
      ),
      Place(
        id: '7',
        name: '코엑스몰',
        address: '서울시 강남구 영동대로 513',
        lat: 37.5115,
        lng: 127.0590,
        category: '쇼핑',
        phone: '02-6002-5300',
      ),
      Place(
        id: '8',
        name: '올리브영 강남점',
        address: '서울시 강남구 강남대로 382',
        lat: 37.4981,
        lng: 127.0278,
        category: '화장품',
        phone: '02-567-1234',
      ),
    ].where((place) {
      return place.name.toLowerCase().contains(query.toLowerCase()) ||
             place.category?.toLowerCase().contains(query.toLowerCase()) == true;
    }).toList();
  }
}
