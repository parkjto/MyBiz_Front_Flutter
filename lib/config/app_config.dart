/// 앱 설정 관리 클래스
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
