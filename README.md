# MyBiz - 소상공인을 위한 AI 비서
<img width="3200" height="1800" alt="image" src="https://github.com/user-attachments/assets/3ae006b3-61bb-49e5-a3ff-a4d40a3ca136" />

AI 기술을 활용하여 매출 분석, 리뷰 분석, 광고 생성, 정부 정책 정보 제공 등 비즈니스 관리에 필요한 모든 기능을 종합적으로 지원합니다. 
MyBiz는 다양한 연령대의 사용자가 손쉽게 접근하고 활용할 수 있도록 직관적인 구조로 설계되었습니다.

---
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/b2c54a47-490b-4bc7-a2ac-7d71ad769961" />

## 🌟주요 기능

### 📊 매출 분석

<img width="3200" height="1800" alt="image" src="https://github.com/user-attachments/assets/fa7d7937-55b8-4cf1-8881-cb7f45bc50ff" />

실시간 통계: 매출 데이터를 실시간 차트와 통계로 시각화하여 제공합니다.

AI 인사이트: AI가 매출 흐름과 추이를 분석하여 비즈니스 성장을 위한 인사이트를 도출합니다.

손쉬운 데이터 연동: 사용자가 CSV 파일을 업로드하면 월별 매출 데이터를 자동으로 분석하고 시각화된 결과를 제공합니다.

### 📝 리뷰 분석

<img width="3200" height="1800" alt="image" src="https://github.com/user-attachments/assets/66b2957a-137d-4694-99e7-3e2a69a7efc6" />

AI 기반 요약: 네이버 계정 연동으로 수집된 고객 리뷰를 기반으로 만족도, 긍정 요소, 개선점을 요약 및 분석합니다.

감정 분석: 고객 리뷰의 긍정/부정을 판단하는 감정 분석을 통해 고객 피드백을 체계적으로 관리할 수 있습니다.

키워드 추출: 핵심 키워드를 추출하여 고객의 주요 관심사를 파악하고 서비스 개선에 활용할 수 있습니다.


### 🎯 AI 광고 생성

<img width="3200" height="1800" alt="image" src="https://github.com/user-attachments/assets/3356ccd7-e4dd-449d-92d9-bee1b61c348b" />

맞춤형 광고 제작: 사용자가 사진을 업로드하고 간단한 요청사항을 입력하면, AI가 맞춤형 광고 이미지와 문구를 자동으로 생성합니다.

마케팅 효율 증대: 생성된 광고를 통해 마케팅 활동의 효율성을 높일 수 있습니다.

### 🏛️ 정부 정책 정보

<img width="3200" height="1800" alt="image" src="https://github.com/user-attachments/assets/73c5ea2e-3075-4ef7-b194-3e203f02e70c" />


맞춤 정책 제공: 소상공인을 대상으로 한 지역별 지원 정책 및 제도를 보기 쉽게 정리하여 제공합니다.

실시간 업데이트: 최신 정책 정보를 놓치지 않도록 실시간으로 업데이트합니다.

### 🤖 AI 챗봇

<img width="3200" height="1800" alt="image" src="https://github.com/user-attachments/assets/54ddf1f8-96e1-4508-8833-ddb716d8b87f" />

AI 상담 : 채팅 및 음성인식을 지원하는 AI 챗봇을 통해 언제 어디서든 비즈니스 관련 문의를 해결할 수 있습니다.

다양한 지원: 매출 및 리뷰 분석 결과에 대한 설명부터 홍보 전략 제안까지 폭넓은 비즈니스 조언을 제공합니다.

## 화면 구성

1. **메인페이지** - 대시보드 및 주요 기능 접근
2. **로그인페이지** - 소셜 로그인 (카카오, 네이버, 구글)
3. **가입정보** - 사용자 및 사업자 정보 입력
4. **광고생성** - AI 기반 광고 생성
5. **매출분석** - 매출 통계 및 분석
6. **리뷰분석** - 고객 리뷰 분석
7. **마이페이지** - 사용자 정보 관리
8. **AI챗봇** - AI 상담 서비스
9. **정부정책** - 정부 지원 정책 정보

## 기술 스택

- **Framework**: Flutter
- **Language**: Dart
- **UI Library**: Material Design
- **Font**: Google Fonts (Inter)
- **Charts**: fl_chart
- **Image Picker**: image_picker
- **HTTP**: http

## 설치 및 실행

### 필수 요구사항
- Flutter SDK 3.0.0 이상
- Dart SDK 3.0.0 이상
- Android Studio / VS Code

### 설치 방법

1. 저장소 클론
```bash
git clone [repository-url]
cd mybiz_app
```

2. 의존성 설치
```bash
flutter pub get
```

3. 앱 실행
```bash
flutter run
```

### 빌드

#### Android APK 빌드
```bash
flutter build apk --release
```

#### iOS 빌드
```bash
flutter build ios --release
```

## 프로젝트 구조

```
lib/
├── main.dart                 # 앱 진입점
├── screens/                  # 화면 파일들
│   ├── main_page.dart       # 메인페이지
│   ├── login_page.dart      # 로그인페이지
│   ├── signup_page.dart     # 가입정보
│   ├── ad_creation_page.dart # 광고생성
│   ├── revenue_analysis_page.dart # 매출분석
│   ├── review_analysis_page.dart # 리뷰분석
│   ├── my_page.dart         # 마이페이지
│   ├── ai_chatbot_page.dart # AI챗봇
│   └── government_policy_page.dart # 정부정책
└── assets/                  # 리소스 파일들
    ├── images/
    └── icons/
```

## 주요 특징

### 🎨 디자인
- Figma 디자인 기반 구현
- 일관된 색상 체계 (Primary: #20A6FE)
- 반응형 UI 디자인
- Material Design 가이드라인 준수

### 🔧 기능
- 네비게이션 기반 화면 전환
- 상태 관리 (StatefulWidget 활용)
- 다이얼로그 및 모달 구현
- 차트 및 그래프 시각화

### 📱 사용자 경험
- 직관적인 사용자 인터페이스
- 부드러운 애니메이션 효과
- 로딩 상태 표시
- 에러 처리 및 피드백

