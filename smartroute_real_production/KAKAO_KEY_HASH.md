# 🔑 키 해시 얻는 방법

## 1️⃣ Windows PC에서 키 해시 얻기

### 방법 1: keytool 명령어 (권장)

**명령 프롬프트(cmd) 또는 PowerShell에서 실행:**

```bash
cd %USERPROFILE%\.android
keytool -exportcert -alias androiddebugkey -keystore debug.keystore -storepass android -keypass android | certutil -hashfile - SHA1
```

**또는 더 간단하게:**

```bash
keytool -list -v -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore -storepass android -keypass android
```

### 방법 2: Android Studio 사용

1. Android Studio 열기
2. **Gradle** 탭 클릭
3. **app** → **Tasks** → **android** → **signingReport** 더블클릭
4. **SHA1** 값 복사

---

## 2️⃣ SHA1을 키 해시로 변환

### 온라인 변환기 사용 (가장 쉬움!)

**사이트:** https://tomeko.net/online_tools/hex_to_base64.php

1. SHA1 값에서 **콜론(:) 제거**
   - 예: `AA:BB:CC:DD:EE` → `AABBCCDDEE`
2. 변환기에 입력
3. **Base64** 값 복사
4. 카카오 콘솔 **"키 해시"**란에 붙여넣기

---

## 3️⃣ 카카오 콘솔 설정 확인

### ✅ 체크리스트

- [ ] **패키지명**: `com.example.smartroute` 입력됨
- [ ] **키 해시**: Base64 값 입력됨
- [ ] **맨 아래 "저장" 버튼 클릭!** ← 이거 안 하면 소용없음!

---

## 4️⃣ 앱 재실행

**프로젝트 폴더에서 실행:**

```bash
flutter clean
flutter pub get
flutter run
```

---

## 💡 참고

### 디버그 모드에서는 키 해시 없어도 될 수도 있습니다!

만약 키 해시 없이도 작동한다면:
- 릴리즈 빌드할 때만 추가하면 됨
- 지금은 **패키지명만 저장**하고 실행해보세요!

---

## 🚨 문제 해결

### "키 해시가 일치하지 않습니다" 에러

1. `flutter clean` 실행
2. 앱 삭제 후 재설치
3. 키 해시 다시 확인

### 지도가 여전히 안 보임

1. 카카오 콘솔에서 **"저장" 버튼** 눌렀는지 확인
2. **패키지명** 정확히 일치하는지 확인
3. AndroidManifest.xml에 **네이티브 앱 키** 있는지 확인

---

## ✅ 최종 확인사항

**카카오 콘솔:**
- ✅ 패키지명: `com.example.smartroute`
- ✅ 키 해시: (선택사항, 디버그 모드에서는 없어도 OK)
- ✅ **저장 버튼 클릭!**

**AndroidManifest.xml:**
```xml
<meta-data
    android:name="com.kakao.sdk.AppKey"
    android:value="be79dcd30a974c835da91532b24c9dc5"/>
```

**실행:**
```bash
flutter clean
flutter pub get
flutter run
```

**이제 Kakao Map이 표시됩니다!** 🗺️✨
