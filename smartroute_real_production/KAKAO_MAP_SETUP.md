# 🗺️ Kakao Map 설정 가이드

## ✅ 현재 상태
- **REST API 키**: bd922d4f6ec8c088349e6985b6642e02 ✅
- **JavaScript 키**: 2d1faa8f61e158a807c397a01b529982 ✅
- **KakaoMapWidget**: 완성 ✅
- **MapTab 통합**: 완료 ✅

---

## 🚀 실행 방법

### 1️⃣ 패키지 설치
```bash
cd smartroute_real_production
flutter pub get
```

### 2️⃣ 앱 실행
```bash
# Chrome에서 실행
flutter run -d chrome

# 또는 다른 디바이스
flutter devices  # 디바이스 목록 확인
flutter run -d <device-id>
```

---

## ⚠️ 카카오 개발자 설정 필수!

### 🔐 플랫폼 도메인 등록 (반드시 해야 함!)

#### Chrome에서 테스트할 경우:
1. [카카오 개발자 콘솔](https://developers.kakao.com) 접속
2. **내 애플리케이션** → **앱 설정** → **플랫폼**
3. **Web 플랫폼 등록** 클릭
4. 다음 도메인들을 추가:
```
http://localhost:3000
http://localhost:8080
http://127.0.0.1:3000
http://127.0.0.1:8080
```

#### 실제 배포할 경우:
```
https://yourdomain.com
https://www.yourdomain.com
```

**⚠️ 주의**: 도메인을 등록하지 않으면 지도가 표시되지 않습니다!

---

## 🗺️ 지도 기능 설명

### 1. **자동 마커 표시**
- 일정에 추가된 장소가 자동으로 지도에 표시됩니다
- 각 마커는 순서대로 번호가 표시됩니다

### 2. **마커 상호작용**
- 마커에 마우스 오버 → 장소 이름 표시
- 마커 클릭 → 상세 정보

### 3. **지도 컨트롤**
- **줌 컨트롤**: 우측에 +/- 버튼
- **지도 타입**: 일반 지도 / 스카이뷰 전환

### 4. **자동 중심 이동**
- 첫 번째 장소를 중심으로 지도 표시
- 모든 마커가 보이도록 자동 줌 레벨 조정

---

## 🎯 테스트 시나리오

### 시나리오 1: 장소 추가 후 지도 확인
```
1. 앱 실행
2. 하단 "지도" 탭 선택
3. 상단 검색바 클릭
4. "스타벅스" 검색
5. + 버튼으로 추가
6. 지도 탭으로 돌아오기
7. 🗺️ 실제 Kakao 지도에 마커 표시 확인!
```

### 시나리오 2: 여러 장소 추가
```
1. "카페" 검색 → 2개 추가
2. "은행" 검색 → 1개 추가
3. 지도 탭 확인
4. 🗺️ 3개 마커 모두 표시!
5. 마커에 마우스 올리면 이름 표시
```

### 시나리오 3: AI 최적화 후 지도 확인
```
1. 4개 이상 장소 추가
2. "일정" 탭 이동
3. "AI 최적화" 버튼 클릭
4. "지도" 탭으로 돌아오기
5. 🗺️ 최적화된 순서로 마커 표시!
```

---

## 🔧 문제 해결

### 문제 1: 지도가 하얀 화면으로 표시됨
**원인**: 도메인이 등록되지 않음

**해결**:
1. 카카오 개발자 콘솔 접속
2. Web 플랫폼에 `http://localhost:3000` 등록
3. 앱 재시작

### 문제 2: "API key is invalid" 에러
**원인**: JavaScript 키가 잘못됨

**해결**:
1. `lib/app/config.dart` 파일 열기
2. `kakaoJavascriptKey` 값 확인
3. 카카오 개발자 콘솔에서 JavaScript 키 복사
4. 다시 붙여넣기

### 문제 3: 마커가 표시되지 않음
**원인**: 장소가 일정에 추가되지 않음

**해결**:
1. 검색 후 + 버튼 확실히 클릭
2. "일정" 탭에서 장소가 있는지 확인
3. 지도 탭으로 돌아오기

### 문제 4: Chrome에서 실행 안됨
**원인**: webview_flutter는 Chrome Web에서 제한적

**해결**:
```bash
# 모바일 에뮬레이터나 실제 기기에서 실행
flutter run -d <android-device-id>
flutter run -d <ios-device-id>
```

---

## 📱 지원 플랫폼

### ✅ 완벽 지원
- Android (실제 기기)
- iOS (실제 기기)
- Android 에뮬레이터
- iOS 시뮬레이터

### ⚠️ 제한적 지원
- Chrome Web (WebView 제한)

**권장**: 모바일 기기나 에뮬레이터에서 테스트!

---

## 🎨 커스터마이징

### 지도 초기 위치 변경
`lib/app/config.dart`:
```dart
static const double defaultLat = 37.5665; // 위도
static const double defaultLng = 126.9780; // 경도
```

### 지도 줌 레벨 변경
`lib/widgets/map/kakao_map_widget.dart`:
```dart
final int level; // 1(가까움) ~ 14(멀리)
```

### 마커 스타일 변경
`kakao_map_widget.dart`의 HTML 부분 수정

---

## 📝 주요 파일

```
lib/
├── app/
│   └── config.dart                    # API 키 설정
├── widgets/
│   └── map/
│       └── kakao_map_widget.dart      # 지도 위젯
├── features/
│   └── map/
│       └── views/
│           └── main_screen.dart       # 지도 탭
└── services/
    └── kakao_search_service.dart      # 장소 검색
```

---

## 🎉 완성!

이제 **실제 Kakao 지도**가 작동합니다!

**테스트 순서**:
1. ✅ `flutter pub get`
2. ✅ 카카오 개발자 콘솔에서 도메인 등록
3. ✅ `flutter run -d chrome`
4. ✅ 장소 추가
5. ✅ 지도 확인!

**문제 발생 시**: 이 가이드의 "문제 해결" 섹션 참고!
