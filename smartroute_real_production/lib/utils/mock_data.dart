import '../models/place.dart';
import '../models/itinerary_item.dart';

class MockDataGenerator {
  static final List<Place> samplePlaces = [
    Place(id: '1', name: 'KB국민은행 강남점', address: '서울시 강남구 테헤란로 123', lat: 37.5012, lng: 127.0396, category: '은행', phone: '02-1234-5678', rating: 4.2, reviewCount: 128),
    Place(id: '2', name: '이마트 역삼점', address: '서울시 강남구 역삼동 456', lat: 37.5000, lng: 127.0360, category: '마트', phone: '02-2345-6789', rating: 4.5, reviewCount: 892),
    Place(id: '3', name: '온누리약국 테헤란점', address: '서울시 강남구 테헤란로 130', lat: 37.5015, lng: 127.0400, category: '약국', phone: '02-3456-7890', rating: 4.8, reviewCount: 45),
    Place(id: '4', name: '강남우체국', address: '서울시 강남구 논현로 789', lat: 37.4990, lng: 127.0350, category: '우체국', phone: '1588-1300', rating: 4.0, reviewCount: 67),
    Place(id: '5', name: '스타벅스 역삼역점', address: '서울시 강남구 역삼로 100', lat: 37.5005, lng: 127.0370, category: '카페', phone: '1522-3232', rating: 4.6, reviewCount: 234),
    Place(id: '6', name: '맥도날드 강남점', address: '서울시 강남구 강남대로 200', lat: 37.5020, lng: 127.0380, category: '식당', rating: 4.3, reviewCount: 567),
    Place(id: '7', name: 'GS25 테헤란점', address: '서울시 강남구 테헤란로 140', lat: 37.5018, lng: 127.0402, category: '편의점', rating: 4.1, reviewCount: 89),
    Place(id: '8', name: '신한은행 역삼지점', address: '서울시 강남구 역삼동 500', lat: 37.5008, lng: 127.0365, category: '은행', phone: '02-4567-8901', rating: 4.4, reviewCount: 156),
    Place(id: '9', name: '이디야커피 강남점', address: '서울시 강남구 논현로 800', lat: 37.4995, lng: 127.0355, category: '카페', phone: '02-5678-9012', rating: 4.5, reviewCount: 178),
    Place(id: '10', name: '올리브영 역삼점', address: '서울시 강남구 역삼로 110', lat: 37.5003, lng: 127.0368, category: '쇼핑', rating: 4.7, reviewCount: 345),
    Place(id: '11', name: '세븐일레븐 강남점', address: '서울시 강남구 강남대로 210', lat: 37.5022, lng: 127.0382, category: '편의점', rating: 4.2, reviewCount: 92),
    Place(id: '12', name: '파리바게뜨 역삼점', address: '서울시 강남구 역삼동 480', lat: 37.5006, lng: 127.0363, category: '베이커리', phone: '02-6789-0123', rating: 4.6, reviewCount: 267),
    Place(id: '13', name: 'CU 테헤란점', address: '서울시 강남구 테헤란로 150', lat: 37.5019, lng: 127.0404, category: '편의점', rating: 4.1, reviewCount: 78),
    Place(id: '14', name: '우리은행 강남지점', address: '서울시 강남구 논현로 810', lat: 37.4993, lng: 127.0353, category: '은행', phone: '02-7890-1234', rating: 4.3, reviewCount: 134),
    Place(id: '15', name: '투썸플레이스 역삼점', address: '서울시 강남구 역삼로 120', lat: 37.5004, lng: 127.0369, category: '카페', phone: '02-8901-2345', rating: 4.7, reviewCount: 289),
    Place(id: '16', name: '롯데리아 강남점', address: '서울시 강남구 강남대로 220', lat: 37.5024, lng: 127.0384, category: '식당', rating: 4.2, reviewCount: 456),
    Place(id: '17', name: '다이소 역삼점', address: '서울시 강남구 역삼동 490', lat: 37.5007, lng: 127.0364, category: '쇼핑', rating: 4.5, reviewCount: 567),
    Place(id: '18', name: '미니스톱 테헤란점', address: '서울시 강남구 테헤란로 160', lat: 37.5020, lng: 127.0406, category: '편의점', rating: 4.0, reviewCount: 65),
    Place(id: '19', name: '하나은행 역삼점', address: '서울시 강남구 논현로 820', lat: 37.4994, lng: 127.0354, category: '은행', phone: '02-9012-3456', rating: 4.4, reviewCount: 123),
    Place(id: '20', name: '엔제리너스 강남점', address: '서울시 강남구 역삼로 130', lat: 37.5005, lng: 127.0370, category: '카페', phone: '02-0123-4567', rating: 4.6, reviewCount: 198),
  ];

  static List<ItineraryItem> getSampleItinerary() {
    return [
      ItineraryItem(id: 'item_1', place: samplePlaces[0], order: 1, transportMode: TransportMode.walk),
      ItineraryItem(id: 'item_2', place: samplePlaces[1], order: 2, transportMode: TransportMode.walk),
      ItineraryItem(id: 'item_3', place: samplePlaces[2], order: 3, transportMode: TransportMode.walk),
      ItineraryItem(id: 'item_4', place: samplePlaces[3], order: 4, transportMode: TransportMode.walk),
    ];
  }

  static List<Place> getCafes() => samplePlaces.where((p) => p.category == '카페').toList();
  static List<Place> getBanks() => samplePlaces.where((p) => p.category == '은행').toList();
  static List<Place> getConvenience() => samplePlaces.where((p) => p.category == '편의점').toList();
}
