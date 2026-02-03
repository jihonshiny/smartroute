# 🔍 앱 크래시 로그 확인 가이드

## 🔴 **증상**
- 앱 설치 성공
- 앱 실행 즉시 종료
- "개발자가 오류를 고쳐야 합니다" 메시지

---

## ✅ **수정 사항**

### AndroidManifest.xml에 추가됨:
```xml
android:usesCleartextTraffic="true"
```

**이유:** WebView로 카카오맵을 로드할 때 HTTP 요청이 필요함

---

## 🚀 **먼저 테스트**

### 1️⃣ 새 버전 실행
```bash
cd "C:\Users\SAMSUNG\Downloads\smartroute_CRASH_FIX\smartroute_real_production"
flutter clean
flutter pub get
flutter run
```

### 2️⃣ 앱 실행 확인
- ✅ 앱이 실행되면 성공!
- ❌ 여전히 크래시 → 다음 단계로

---

## 🔍 **크래시 로그 확인 방법**

### 방법 1: PowerShell에서 (권장!)

#### 1️⃣ 휴대폰 연결 확인
```bash
adb devices
```

**결과:**
```
List of devices attached
R5CY31WMTVE    device
```

#### 2️⃣ 로그 시작
```bash
adb logcat -s flutter
```

#### 3️⃣ 앱 실행
- 다른 창에서 `flutter run` 또는
- 휴대폰에서 앱 아이콘 터치

#### 4️⃣ 에러 확인
**빨간색 에러 메시지** 복사해서 보내주세요!

---

### 방법 2: 전체 로그

#### 1️⃣ 로그 필터 없이 시작
```bash
adb logcat *:E
```

**E = Error만 표시**

#### 2️⃣ 앱 실행 후 에러 확인
```
E/AndroidRuntime: FATAL EXCEPTION: main
E/AndroidRuntime: Process: com.example.smartroute
E/AndroidRuntime: java.lang.RuntimeException: ...
```

**이 부분을 전부 복사해서 보내주세요!**

---

### 방법 3: 파일로 저장

```bash
adb logcat > crash_log.txt
```

**앱 실행 후:**
- Ctrl+C로 중단
- crash_log.txt 파일 열기
- 에러 부분 찾기

---

## 🎯 **자주 나오는 에러와 해결**

### 에러 1: `com.kakao.sdk` 관련
```
Caused by: java.lang.IllegalStateException: 
KakaoSdk.init must be called before using kakao sdk
```

**해결:** Kakao SDK 초기화 코드 추가 필요

---

### 에러 2: `WebView` 관련
```
net::ERR_CLEARTEXT_NOT_PERMITTED
```

**해결:** 이미 추가됨! (usesCleartextTraffic)

---

### 에러 3: Dart 코드 에러
```
Unhandled Exception: type 'Null' is not a subtype of type 'X'
```

**해결:** 코드에서 null 체크 필요

---

## 💡 **가능성 높은 원인**

### 1. **ReservationStatus 정의 안 됨**
**증상:** 앱 시작 시 바로 크래시

**확인:**
```dart
// lib/models/reservation.dart
enum ReservationStatus { pending, confirmed, cancelled, completed }
```

---

### 2. **NotificationType 정의 안 됨**
**증상:** 특정 화면 진입 시 크래시

**확인:**
```dart
// lib/models/notification.dart
enum NotificationType { promotion, update, alert }
```

---

### 3. **Kakao SDK 초기화 실패**
**증상:** 앱 시작 시 바로 크래시

**확인:** AndroidManifest.xml
```xml
<meta-data
    android:name="com.kakao.sdk.AppKey"
    android:value="be79dcd30a974c835da91532b24c9dc5"/>
```

---

## 🚨 **긴급 회피 방법**

### 만약 계속 크래시 난다면:

#### 옵션 1: 디버그 모드로 실행
```bash
flutter run --debug --verbose
```

**에러 메시지가 터미널에 바로 표시됩니다!**

---

#### 옵션 2: 코드 에러 무시하고 실행
```bash
flutter run --no-sound-null-safety
```

**null safety 에러를 무시하고 실행**

---

## 📞 **다음 단계**

### 1️⃣ 먼저 이 버전 실행
```bash
flutter clean
flutter pub get
flutter run
```

### 2️⃣ 여전히 크래시 시
```bash
adb logcat -s flutter
```

**에러 메시지 전체를 복사해서 보내주세요!**

### 3️⃣ 또는 간단하게
```bash
flutter run --verbose
```

**터미널 출력을 전부 복사해서 보내주세요!**

---

## ✅ **성공 메시지**

**앱이 정상 실행되면 이렇게 표시됩니다:**
```
Flutter run key commands.
r Hot reload. 🔥🔥🔥
R Hot restart.
h List all available interactive commands.
d Detach (terminate "flutter run" but leave application running).
c Clear the screen
q Quit (terminate the application on the device).
```

**이 메시지가 나오면 성공입니다!** 🎉

---

## 🗺️ **Kakao Map 확인**

앱 실행 후:
1. 하단 **"지도"** 탭 선택
2. Kakao Map 표시 확인
3. 검색바에서 장소 검색

**지도가 보이면 완전 성공!** 🗺️✨

---

## 📌 **요약**

```bash
# 1. 새 버전 실행
flutter clean && flutter pub get && flutter run

# 2. 크래시 시 로그 확인
adb logcat -s flutter

# 3. 또는 간단하게
flutter run --verbose
```

**로그를 보내주시면 정확히 고쳐드리겠습니다!** 🔥
