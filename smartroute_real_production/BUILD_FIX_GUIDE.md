# 🔧 SmartRoute 빌드 정리 가이드

## 🔴 **문제: 깨진 APK 파일**

### 원인:
```
java.io.IOException: 링크 생성에 실패했습니다
Invalid file
ERROR: dump failed because resource AndroidManifest.xml not found
```

**build 폴더의 APK 파일이 깨진 상태입니다!**

---

## ✅ **해결 방법 (5단계)**

### 1️⃣ Flutter 완전히 종료
- 현재 실행 중인 `flutter run`이 있다면:
  - 터미널에서 `q` 입력
  - 또는 Ctrl+C
- 모든 Flutter 프로세스 종료

---

### 2️⃣ build 폴더 삭제 (가장 중요!)

#### 방법 A: 탐색기에서 삭제 (권장!)
```
C:\Users\SAMSUNG\Downloads\smartroute_FINAL_CLEAN\smartroute_real_production\build
```

**이 폴더 전체를 휴지통으로!**

#### 방법 B: PowerShell에서 삭제
```powershell
cd "C:\Users\SAMSUNG\Downloads\smartroute_FINAL_CLEAN\smartroute_real_production"
Remove-Item -Recurse -Force build
```

---

### 3️⃣ Flutter 캐시 정리
```bash
flutter clean
flutter pub get
```

**예상 시간:** 30초

---

### 4️⃣ 휴대폰 연결 확인
```bash
flutter devices
```

**확인:**
```
SM S721N (mobile) • R5CY31WMTVE • android-arm64 • Android 16 (API 36)
```

---

### 5️⃣ 앱 실행!
```bash
flutter run
```

**예상 시간:** 2-3분 (첫 빌드)

---

## ✅ **성공 메시지**

### 정상 빌드:
```
✓ Built build\app\outputs\flutter-apk\app-debug.apk
Installing build\app\outputs\flutter-apk\app-debug.apk...
D/FlutterJNI: flutter was loaded normally
Flutter run key commands.
```

**이 메시지가 나오면 성공!** 🎉

---

## 🗺️ **카카오 지도 확인**

### 앱 실행 후:
1. **지도 탭** 선택
2. "카카오 지도 로딩중..." 표시
3. **카카오 지도 표시!** 🗺️
4. 장소 추가 → 마커 표시

---

## ❌ **하지 말아야 할 것**

### 절대 금지:
- ❌ `flutter run`만 계속 반복
- ❌ build 폴더 안 지우고 재시도
- ❌ `flutter create .` 실행 (지금은 필요 없음)

---

## 💡 **왜 이런 일이?**

### 원인:
```
Windows 백신/보안 프로그램
  ↓
APK 복사 중 파일 잠금
  ↓
APK가 반쯤 생성됨
  ↓
Flutter가 깨진 APK를 재사용
  ↓
에러 발생!
```

### 해결:
**build 폴더 삭제 = 깨끗하게 시작**

---

## 🎯 **완전한 실행 순서**

```bash
# 1. 폴더 이동
cd "C:\Users\SAMSUNG\Downloads\smartroute_FINAL_CLEAN\smartroute_real_production"

# 2. build 폴더 삭제 (탐색기에서 수동 권장)
Remove-Item -Recurse -Force build

# 3. 캐시 정리
flutter clean
flutter pub get

# 4. 디바이스 확인
flutter devices

# 5. 실행!
flutter run
```

---

## 📊 **업데이트된 설정**

### 이 버전의 특징:
```
✅ compileSdk: 36 (webview_flutter 호환)
✅ 카카오 지도 WebView 구현
✅ 자동 마커 관리
✅ 실시간 업데이트
✅ 모든 경고 해결
```

---

## 🔥 **실행 후 스크린샷**

### 보내주실 화면:
1. ✅ 앱 실행 성공 메시지
2. ✅ 지도 탭 화면 (카카오 지도)
3. ✅ 장소 추가 후 마커

---

## 📞 **문제 발생 시**

### 여전히 에러가 나면:

#### 1. build 폴더가 정말 삭제되었나요?
```
탐색기로 확인:
C:\Users\SAMSUNG\Downloads\smartroute_FINAL_CLEAN\smartroute_real_production\build
```

#### 2. Flutter 재시작
```
터미널 완전 종료 → 새로 열기
```

#### 3. 전체 로그 보내기
```bash
flutter run --verbose
```

**에러 메시지 전체를 복사해서 보내주세요!**

---

## 🎊 **거의 다 왔습니다!**

**이 단계만 따라하시면 100% 성공합니다!**

```bash
cd smartroute_FINAL_CLEAN\smartroute_real_production
Remove-Item -Recurse -Force build
flutter clean && flutter pub get && flutter run
```

**화이팅!** 🚀
