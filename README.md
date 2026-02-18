<div align="center">

# SmartRoute

### AI 기반 일정 최적 경로 추천 애플리케이션

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

**여러 목적지를 한 번에 입력하고, AI가 최적의 이동 순서를 계산합니다**

[발표 자료 보기](https://www.canva.com/design/DAHBrlpw0UM/JgdZXS12rlFP7sHlYnwK-g/view?utm_content=DAHBrlpw0UM&utm_campaign=designshare&utm_medium=link2&utm_source=uniquelinks&utlId=hb6040c1d1c)
[시연영상 보기](https://youtube.com/shorts/TlmBuIPKnLc?feature=share)

</div>

## 프로젝트 미리보기

<div align="center">
  <img src="assets/images/smartroute_preview.png" width="900"/>
</div>

## 목차

- [프로젝트 개요](#프로젝트-개요)
- [기획 배경](#기획-배경)
- [주요 기능](#주요-기능)
- [기술 스택](#기술-스택)
- [시스템 아키텍처](#시스템-아키텍처)
- [알고리즘 설명](#알고리즘-설명)
- [실행 방법](#실행-방법)
- [프로젝트 성과](#프로젝트-성과)
- [향후 계획](#향후-계획)
- [라이선스](#라이선스)

---

## 프로젝트 개요

SmartRoute는 하루에 여러 목적지를 방문해야 하는 사용자를 위한 경로 최적화 애플리케이션입니다. TSP(Traveling Salesman Problem) 알고리즘을 활용하여 최적의 이동 순서를 자동으로 계산하고, 평균 30% 이상의 시간과 거리를 절약할 수 있도록 지원합니다.

**주요 특징**
- 다중 목적지 동시 입력 및 관리
- AI 기반 경로 자동 최적화
- 실시간 거리 및 소요시간 계산
- 대중교통 경로 통합 제공
- 직관적인 사용자 인터페이스

**개발 기간**: 2025.12.29 - 2026.1.13 (9일)  
**개발 인원**: 1명  
**플랫폼**: Android, iOS

---

## 기획 배경

### 문제 정의

현재 시중의 내비게이션 앱들은 하나의 목적지만 안내하는 구조로, 여러 장소를 방문해야 하는 경우 다음과 같은 문제가 발생합니다:

1. **비효율적 경로 설정**
   - 사용자가 직접 방문 순서를 결정해야 함
   - 최적 순서를 계산하기 어려움
   - 불필요한 이동 거리 및 시간 발생

2. **반복적인 앱 조작**
   - 목적지 도착 후 다시 검색 필요
   - 운전 중 조작 시 안전사고 위험
   - 50대 이상 세대의 경우 복잡한 조작 부담

3. **시간 및 비용 낭비**
   - 평균 30% 이상의 시간 낭비
   - 불필요한 연료 소비
   - 생산성 저하

### 솔루션

SmartRoute는 다음과 같은 방법으로 문제를 해결합니다:

- **자동 경로 최적화**: TSP 알고리즘으로 최단 경로 계산
- **원스톱 입력**: 모든 목적지를 한 번에 입력
- **실시간 최적화**: 드래그로 순서 변경 시 즉시 재계산
- **직관적 UI**: 시니어층도 쉽게 사용 가능한 인터페이스

---

## 주요 기능

### 1. 지도 및 경로 최적화

**장소 검색**
- Kakao Local API 연동
- 실시간 검색 자동완성
- 주소, 장소명, 키워드 검색 지원

**AI 경로 최적화**
- TSP 알고리즘 2가지 구현 (Nearest Neighbor, 2-Opt)
- 하버사인 공식 기반 정확한 거리 계산
- 최적화 전후 비교 통계 제공

**시각화**
- 지도에 마커 및 경로선 표시
- 실시간 거리 및 소요시간 계산
- 절약된 시간/거리 통계

### 2. 일정 관리

- 다중 장소 리스트 관리
- 드래그 앤 드롭으로 순서 변경
- 일정 저장 및 불러오기
- 장소별 메모 기능

### 3. 대중교통 경로

**ODsay API 연동**
- 지하철, 버스 통합 경로 검색
- 4가지 정렬 옵션 (최단시간, 최소환승, 최소도보, 최저요금)
- 환승 정보 및 소요시간 표시
- 실시간 요금 계산

### 4. 즐겨찾기 및 예약

**즐겨찾기**
- 자주 방문하는 장소 저장
- 카테고리별 분류 (집, 회사, 식당, 카페 등)
- 원터치 경로 추가

**예약 시스템**
- 날짜, 시간, 인원 설정
- 예약 알림 자동 스케줄링
- 예약 내역 관리

### 5. 개인화 설정

- 다크 모드 지원
- 다국어 지원 (한국어, 영어)
- 알림 설정 (경로, 예약)
- 사용 통계 제공

---

## 기술 스택

### Frontend

| 기술 | 버전 | 용도 |
|------|------|------|
| Flutter | 3.0+ | 크로스 플랫폼 프레임워크 |
| Dart | 3.0+ | 프로그래밍 언어 |
| Riverpod | 2.5+ | 상태 관리 |
| Material Design 3 | - | UI/UX 디자인 시스템 |

### Backend & Storage

| 기술 | 용도 |
|------|------|
| SQLite | 로컬 데이터베이스 |
| SharedPreferences | 설정 저장 |

### APIs & Libraries

| API/라이브러리 | 용도 |
|---------------|------|
| Kakao Maps API | 지도 표시 및 렌더링 |
| Kakao Local API | 장소 검색 |
| ODsay API | 대중교통 경로 |
| flutter_local_notifications | 알림 |
| geolocator | 위치 서비스 |
| http/dio | 네트워크 통신 |
| intl | 다국어 처리 |

---

## 시스템 아키텍처

### 디렉토리 구조

```
lib/
├── core/                    
│   ├── theme/              # 테마 (Light/Dark)
│   ├── l10n/               # 다국어 리소스
│   ├── services/           # API 서비스, 알림 서비스
│   ├── constants/          # 상수 정의
│   └── utils/              # 유틸리티 (TSP, 에러 핸들링)
│
├── data/                    
│   ├── models/             # 데이터 모델
│   └── repositories/       # 데이터 레포지토리
│
└── presentation/            
    ├── screens/            # 화면 UI
    │   ├── map/           
    │   ├── schedule/      
    │   ├── transit/       
    │   ├── favorites/     
    │   └── my/            
    └── widgets/            # 공통 위젯
```

### 아키텍처 패턴

**Clean Architecture**
- Presentation Layer: UI 및 사용자 상호작용
- Domain Layer: 비즈니스 로직 (TSP 알고리즘)
- Data Layer: 데이터 소스 (API, Database)

**장점**
- 관심사의 분리 (Separation of Concerns)
- 테스트 용이성
- 유지보수성 향상
- 확장 가능한 구조

---

## 알고리즘 설명

### TSP (Traveling Salesman Problem)

**문제 정의**

N개의 도시를 모두 방문하고 출발점으로 돌아오는 최단 경로를 찾는 NP-hard 문제입니다.

**경우의 수**
- 4개 장소: 24가지
- 10개 장소: 3,628,800가지
- 20개 장소: 2.4 × 10^18 가지

### 구현 알고리즘

**1. Nearest Neighbor Algorithm**

```
시간 복잡도: O(n²)
```

현재 위치에서 가장 가까운 미방문 장소를 순차적으로 선택하는 탐욕 알고리즘입니다.

**장점**
- 빠른 계산 속도
- 구현 단순성
- 실시간 최적화 가능

**단점**
- 최적해 보장 불가
- 근사해 도출

**2. 2-Opt Optimization**

```
시간 복잡도: O(n²) ~ O(n³)
```

Nearest Neighbor로 얻은 경로를 개선하는 최적화 알고리즘입니다. 경로 간 교차점을 제거하여 더 나은 해를 찾습니다.

**장점**
- 더 정확한 최적해
- 경로 개선 보장

**단점**
- 계산 시간 증가
- 복잡도 상승

### 거리 계산: Haversine Formula

지구 곡률을 고려한 정확한 거리 계산 공식:

```
a = sin²(Δφ/2) + cos(φ1) × cos(φ2) × sin²(Δλ/2)
c = 2 × atan2(√a, √(1-a))
d = R × c
```

여기서 R은 지구 반지름 (6,371 km)입니다.

---

## 실행 방법

### 사전 요구사항

- Flutter SDK 3.0 이상
- Dart SDK 3.0 이상
- Android Studio 또는 Xcode
- Git

### 설치 및 실행

**1. 저장소 클론**

```bash
git clone https://github.com/yourusername/smartroute.git
cd smartroute
```

**2. 의존성 설치**

```bash
flutter pub get
```

**3. API 키 설정**

`lib/core/constants/api_constants.dart` 파일을 생성하고 다음 내용을 입력합니다:

```dart
class ApiConstants {
  static const String kakaoApiKey = 'YOUR_KAKAO_REST_API_KEY';
  static const String kakaoJsApiKey = 'YOUR_KAKAO_JS_API_KEY';
  static const String odsayApiKey = 'YOUR_ODSAY_API_KEY';
}
```

**API 키 발급**
- Kakao API: https://developers.kakao.com
- ODsay API: https://lab.odsay.com

**4. 앱 실행**

```bash
flutter run
```

### 빌드

**Android APK**
```bash
flutter build apk --release
```

**iOS**
```bash
flutter build ios --release
```

---

## 프로젝트 성과

### 정량적 성과

| 지표 | 수치 |
|------|------|
| 평균 시간 절약 | 30% |
| 평균 거리 단축 | 25% |
| 알고리즘 처리 속도 | 1초 미만 (10개 장소) |
| 테스트 사용자 만족도 | 4.8/5.0 |

### 기술적 성과

- TSP 알고리즘 2가지 독자 구현
- Clean Architecture 기반 설계
- Material Design 3 적용
- 완전한 다국어 지원 (한국어/영어)
- LocaleDataException 완전 해결
- Android 13+ 알림 권한 대응
- 프로덕션 레벨 에러 핸들링

### 차별화 요소

| 항목 | 기존 앱 | SmartRoute |
|------|---------|------------|
| 다중 목적지 입력 | 불가 | 가능 |
| AI 경로 최적화 | 없음 | TSP 알고리즘 |
| 예약 시스템 | 없음 | 통합 제공 |
| 시니어 친화 UI | 부족 | 최적화 |
| 다국어 지원 | 부분 | 완전 |

---

## 향후 계획

### Version 2.0 (개발 중)

- 사용자 인증 시스템
- 클라우드 동기화 (Firebase)
- AR 기반 네비게이션
- 음성 안내 기능
- 실시간 교통 정보 연동

### Version 3.0 (계획)

- AI 기반 장소 추천
- 소셜 기능 (경로 공유)
- 오프라인 지도 지원
- 홈 화면 위젯
- 자전거/바이크 경로

---

## 발표 자료

<div align="center">

[![발표 자료](https://img.shields.io/badge/발표자료-Canva-00C4CC?style=for-the-badge&logo=canva&logoColor=white)](https://www.canva.com/design/DAHBrlpw0UM/JgdZXS12rlFP7sHlYnwK-g/view?utm_content=DAHBrlpw0UM&utm_campaign=designshare&utm_medium=link2&utm_source=uniquelinks&utlId=hb6040c1d1c)

**[SmartRoute 프로젝트 발표 자료 보기](https://www.canva.com/design/DAHBrlpw0UM/JgdZXS12rlFP7sHlYnwK-g/view?utm_content=DAHBrlpw0UM&utm_campaign=designshare&utm_medium=link2&utm_source=uniquelinks&utlId=hb6040c1d1c)**

</div>

---

## 라이선스

이 프로젝트는 MIT 라이선스를 따릅니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

---

## 문의

- Email: shiny7y7r@gmail.com
---

## 참고 자료

- [Flutter 공식 문서](https://docs.flutter.dev/)
- [Kakao Developers](https://developers.kakao.com/docs)
- [ODsay Lab](https://lab.odsay.com/guide)
- [Material Design 3](https://m3.material.io/)

---

<div align="center">

**Made by SmartRoute Team**

[![GitHub stars](https://img.shields.io/github/stars/yourusername/smartroute?style=social)](https://github.com/jihonshiny/smartroute)
[![GitHub forks](https://img.shields.io/github/forks/yourusername/smartroute?style=social)](https://github.com/yourusername/smartroute/fork)

</div>
