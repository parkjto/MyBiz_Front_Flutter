# MyBiz 소셜 로그인 구현 가이드

## 개요
MyBiz Flutter 앱에서 카카오와 네이버 소셜 로그인을 구현했습니다. OAuth 2.0 표준을 따르며, WebView를 통한 인증 플로우를 지원합니다.

## 구현된 기능

### 1. 소셜 로그인 서비스 (`SocialAuthService`)
- **카카오 로그인**: OAuth 인증 URL 생성 및 로그인 처리
- **네이버 로그인**: OAuth 인증 URL 생성 및 로그인 처리
- **WebView 인증**: 앱 내에서 OAuth 인증 진행
- **에러 처리**: 네트워크 오류 및 인증 실패 처리

### 2. 인증 데이터 저장 (`AuthStorageService`)
- **토큰 관리**: 액세스 토큰, 리프레시 토큰 저장
- **사용자 정보**: 로그인한 사용자 정보 저장
- **로그인 상태**: 토큰 유효성 검사 및 로그인 상태 확인
- **데이터 보안**: SharedPreferences를 통한 안전한 저장

### 3. 로그인 페이지 (`LoginPage`)
- **UI 개선**: 로딩 상태 표시 및 버튼 비활성화
- **인증 플로우**: WebView 다이얼로그를 통한 OAuth 인증
- **성공 처리**: 로그인 성공 시 토큰 저장 및 페이지 전환

## API 엔드포인트

### 카카오 로그인
```
GET  /api/auth/kakao/auth-url    - 카카오 OAuth 인증 URL 생성
POST /api/auth/kakao/login       - 카카오 로그인 처리
```

### 네이버 로그인
```
GET  /api/auth/naver/auth-url    - 네이버 OAuth 인증 URL 생성
POST /api/auth/naver/login       - 네이버 로그인 처리
```

## 인증 플로우

### 1. 로그인 버튼 클릭
```
사용자 → 로그인 버튼 클릭 → 로딩 상태 활성화
```

### 2. 인증 URL 요청
```
앱 → 백엔드 API 호출 → OAuth 인증 URL 받기
```

### 3. WebView 인증
```
앱 → WebView 다이얼로그 열기 → OAuth 인증 진행 → 콜백 코드 받기
```

### 4. 로그인 처리
```
앱 → 백엔드에 콜백 코드 전송 → 토큰 및 사용자 정보 받기
```

### 5. 데이터 저장 및 전환
```
앱 → 토큰/사용자 정보 저장 → 성공 메시지 표시 → 메인 페이지로 이동
```

## 설정

### API 설정 (`ApiConfig`)
```dart
class ApiConfig {
  static const String devBaseUrl = 'http://localhost:3000';
  static const String prodBaseUrl = 'https://your-production-api.com';
  
  // 환경에 따른 동적 URL 설정
  static String get baseUrl => isProduction ? prodBaseUrl : devBaseUrl;
}
```

### 환경별 설정
- **개발 환경**: `localhost:3000` (백엔드 개발 서버)
- **프로덕션 환경**: 실제 도메인 URL

## 의존성

### 추가된 패키지
```yaml
dependencies:
  webview_flutter: ^4.4.2  # OAuth WebView 지원
  shared_preferences: ^2.2.2  # 토큰 저장
  dio: ^5.3.2  # HTTP 클라이언트
```

## 사용법

### 1. 로그인 페이지에서
```dart
// 카카오 로그인
await _handleKakaoLogin(context);

// 네이버 로그인  
await _handleNaverLogin(context);
```

### 2. 인증 상태 확인
```dart
final authService = AuthStorageService();
final isLoggedIn = await authService.isLoggedIn();
```

### 3. 토큰 가져오기
```dart
final token = await authService.getAccessToken();
```

## 보안 고려사항

### 1. 토큰 관리
- 액세스 토큰은 만료 시간과 함께 저장
- 리프레시 토큰은 안전하게 보관
- 로그아웃 시 모든 토큰 삭제

### 2. 네트워크 보안
- HTTPS 통신 필수 (프로덕션)
- 타임아웃 설정으로 무한 대기 방지
- 에러 처리로 민감 정보 노출 방지

### 3. 데이터 저장
- SharedPreferences를 통한 안전한 저장
- 민감한 정보는 암호화 고려

## 에러 처리

### 1. 네트워크 오류
- 연결 타임아웃 처리
- 서버 응답 오류 처리
- 사용자 친화적 오류 메시지

### 2. 인증 실패
- OAuth 인증 실패 처리
- 토큰 만료 처리
- 재로그인 안내

## 테스트

### 1. 개발 환경 테스트
```bash
# 백엔드 서버 실행
cd MyBiz-BE
npm start

# Flutter 앱 실행
cd MyBiz_Front_Flutter-main
flutter run
```

### 2. 테스트 시나리오
- 정상 로그인 플로우
- 네트워크 오류 상황
- 토큰 만료 상황
- 로그아웃 및 재로그인

## 향후 개선사항

### 1. 기능 개선
- 자동 토큰 갱신
- 생체 인증 연동
- 소셜 계정 연동

### 2. 보안 강화
- 토큰 암호화 저장
- 인증 상태 검증 강화
- 세션 관리 개선

### 3. 사용자 경험
- 로그인 히스토리
- 자동 로그인 옵션
- 소셜 계정 관리

## 문제 해결

### 1. WebView 로딩 실패
- 인터넷 연결 확인
- 백엔드 서버 상태 확인
- API 엔드포인트 URL 확인

### 2. 토큰 저장 실패
- SharedPreferences 권한 확인
- 디바이스 저장 공간 확인
- 앱 재시작 후 재시도

### 3. 로그인 후 페이지 전환 실패
- 라우트 설정 확인
- 네비게이션 스택 상태 확인
- 메인 페이지 존재 여부 확인

## 연락처
구현 관련 문의사항이 있으시면 개발팀에 문의해주세요.
