/// HTML 태그를 제거하고 순수 텍스트만 추출하는 유틸리티 클래스
class HtmlUtils {
  /// HTML 태그를 제거하고 순수 텍스트만 반환
  static String removeHtmlTags(String htmlText) {
    if (htmlText.isEmpty) return '';
    
    // 정규식을 사용하여 HTML 태그 제거
    // <b>, </b>, <strong>, </strong> 등의 태그 제거
    String cleanText = htmlText
        .replaceAll(RegExp(r'<[^>]*>'), '') // 모든 HTML 태그 제거
        .replaceAll('&nbsp;', ' ') // HTML 공백 문자를 일반 공백으로 변환
        .replaceAll('&amp;', '&') // HTML 앰퍼샌드를 일반 앰퍼샌드로 변환
        .replaceAll('&lt;', '<') // HTML < 기호를 일반 < 기호로 변환
        .replaceAll('&gt;', '>') // HTML > 기호를 일반 > 기호로 변환
        .replaceAll('&quot;', '"') // HTML 따옴표를 일반 따옴표로 변환
        .replaceAll('&#39;', "'") // HTML 작은따옴표를 일반 작은따옴표로 변환
        .trim(); // 앞뒤 공백 제거
    
    return cleanText;
  }

  /// 텍스트에서 특정 키워드를 강조 표시 (볼드 처리)
  static String highlightKeyword(String text, String keyword) {
    if (keyword.isEmpty || text.isEmpty) return text;
    
    // 키워드를 찾아서 **로 감싸기 (마크다운 스타일)
    final regex = RegExp(keyword, caseSensitive: false);
    return text.replaceAllMapped(regex, (match) => '**${match.group(0)}**');
  }

  /// 텍스트가 HTML 태그를 포함하고 있는지 확인
  static bool containsHtmlTags(String text) {
    return RegExp(r'<[^>]*>').hasMatch(text);
  }
}
