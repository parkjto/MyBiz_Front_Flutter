# MyBiz - 비즈니스 관리 앱

MyBiz는 소상공인을 위한 종합 비즈니스 관리 애플리케이션입니다. AI 기술을 활용한 매출 분석, 리뷰 분석, 광고 생성, 정부정책 정보 제공 등의 기능을 제공합니다.

## 주요 기능

### 📊 매출 분석
- 실시간 매출 통계 및 차트
- AI 기반 매출 분석 및 인사이트
- 기간별 매출 비교 분석

### 📝 리뷰 분석
- 고객 리뷰 감정 분석
- 키워드 추출 및 분석
- AI 기반 개선 제안

### 🎯 AI 광고 생성
- AI를 활용한 맞춤형 광고 문구 생성
- 이미지 업로드 및 광고 제작
- 광고 효과 분석

### 🏛️ 정부정책 정보
- 업종별 정부 지원 정책 정보
- 정책 신청 및 관리
- 실시간 정책 업데이트

### 🤖 AI 챗봇
- 24/7 비즈니스 상담 서비스
- 자연어 기반 질의응답
- 맞춤형 비즈니스 조언

### 👤 마이페이지
- 사용자 정보 관리
- 가게 정보 관리
- 연결된 서비스 관리

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

## 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다.

## 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 문의사항

프로젝트에 대한 문의사항이 있으시면 이슈를 생성해 주세요.

---

**MyBiz** - 소상공인의 디지털 전환을 위한 최고의 파트너 