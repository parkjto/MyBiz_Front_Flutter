# 데이터 토글 가이드

## 개요
Flutter 앱에서 하드코딩된 샘플 데이터와 실제 API 데이터를 쉽게 전환할 수 있는 기능을 제공합니다.

## 설정 방법

### 1. 설정 파일 위치
`lib/config/app_config.dart` 파일에서 설정을 변경할 수 있습니다.

### 2. 주요 설정 옵션

```dart
class AppConfig {
  // 하드코딩된 데이터 사용 여부
  // true: 하드코딩된 샘플 데이터 사용 (개발/테스트용)
  // false: 실제 API 데이터 사용 (프로덕션용)
  static const bool useHardcodedData = true;
  
  // 디버그 모드
  static const bool debugMode = true;
  
  // API 타임아웃 설정
  static const int apiTimeoutSeconds = 30;
  
  // 리뷰 표시 개수 제한
  static const int maxDisplayReviews = 5;
  
  // 폴링 간격 (초)
  static const int pollingIntervalSeconds = 3;
  
  // 최대 폴링 횟수
  static const int maxPollingAttempts = 100;
}
```

## 사용 방법

### 하드코딩된 데이터 사용 (개발/테스트)
```dart
static const bool useHardcodedData = true;
```

**특징:**
- 50개의 실제 리뷰 데이터 사용
- API 호출 없이 즉시 데이터 표시
- 개발 및 테스트에 최적화
- 디버그 로그 활성화

### 실제 API 데이터 사용 (프로덕션)
```dart
static const bool useHardcodedData = false;
```

**특징:**
- 백엔드 API에서 실제 데이터 가져오기
- 네트워크 연결 필요
- 실제 스크래핑 및 분석 결과 표시
- 프로덕션 환경에 최적화

## 데이터 구조

### 하드코딩된 샘플 데이터
- **총 50개 리뷰**: 실제 사용자 리뷰 기반
- **감정 분석**: 긍정(32개), 보통(10개), 부정(8개)
- **키워드 분석**: 긍정/부정 키워드 자동 추출
- **평점 매핑**: 감정에 따른 평점 자동 계산

### 실제 API 데이터
- 백엔드에서 스크래핑된 실제 리뷰
- AI 분석 결과
- 실시간 데이터 업데이트

## 디버그 모드

### 디버그 로그 활성화
```dart
static const bool debugMode = true;
```

**표시되는 로그:**
- API 응답 데이터
- 분석 결과 데이터
- 키워드 추출 결과
- 데이터 파싱 과정

### 디버그 로그 비활성화
```dart
static const bool debugMode = false;
```

## 성능 최적화 설정

### 폴링 설정
```dart
// 폴링 간격 (초)
static const int pollingIntervalSeconds = 3;

// 최대 폴링 횟수
static const int maxPollingAttempts = 100;
```

### 표시 제한
```dart
// 리뷰 표시 개수 제한
static const int maxDisplayReviews = 5;
```

## 전환 시나리오

### 개발 → 프로덕션 전환
1. `useHardcodedData = false`로 변경
2. `debugMode = false`로 변경
3. 백엔드 서버 연결 확인
4. 앱 재시작

### 프로덕션 → 개발 전환
1. `useHardcodedData = true`로 변경
2. `debugMode = true`로 변경 (선택사항)
3. 앱 재시작

## 문제 해결

### 하드코딩된 데이터가 표시되지 않는 경우
1. `useHardcodedData = true` 확인
2. 앱 재시작
3. 디버그 로그 확인

### API 데이터가 표시되지 않는 경우
1. `useHardcodedData = false` 확인
2. 백엔드 서버 연결 상태 확인
3. 네트워크 권한 확인
4. API 엔드포인트 확인

## 파일 구조

```
lib/
├── config/
│   └── app_config.dart          # 앱 설정
├── data/
│   └── sample_reviews.dart      # 샘플 데이터
└── screens/
    └── scraping_page.dart       # 메인 화면
```

## 주의사항

1. **설정 변경 후 앱 재시작 필요**
2. **프로덕션 배포 시 `debugMode = false` 권장**
3. **하드코딩된 데이터는 개발/테스트 목적으로만 사용**
4. **실제 사용자 데이터는 API를 통해서만 접근**
