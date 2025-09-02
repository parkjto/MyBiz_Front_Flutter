import 'package:dio/dio.dart';
import '../config/api_config.dart';
import 'auth_storage_service.dart';

/// Sales 관련 API 호출을 담당하는 서비스
class SalesService {
  final Dio _dio = Dio();
  final AuthStorageService _auth = AuthStorageService();

  SalesService() {
    _dio.options.baseUrl = ApiConfig.baseUrl;
    _dio.options.connectTimeout = const Duration(milliseconds: ApiConfig.connectionTimeout);
    _dio.options.receiveTimeout = const Duration(milliseconds: ApiConfig.receiveTimeout);
    _dio.options.headers = Map<String, dynamic>.from(ApiConfig.defaultHeaders);

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _auth.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ));
  }

  // ===== Helpers =====
  String _toUtcIso(DateTime dt) => dt.toUtc().toIso8601String();

  Map<String, String> monthRangeUtc({required int year, required int month}) {
    final start = DateTime.utc(year, month, 1, 0, 0, 0);
    final end = DateTime.utc(year, month + 1, 0, 23, 59, 59);
    return {
      'start': _toUtcIso(start),
      'end': _toUtcIso(end),
    };
  }

  // 오늘/주간 범위
  DateTime _startOfTodayUtc() {
    final now = DateTime.now().toUtc();
    return DateTime.utc(now.year, now.month, now.day, 0, 0, 0);
  }
  DateTime _endOfTodayUtc() {
    final now = DateTime.now().toUtc();
    return DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
  }
  DateTime _startOfWeekUtc() {
    final now = DateTime.now().toUtc();
    final diff = now.weekday - 1; // 1=Mon
    final monday = now.subtract(Duration(days: diff));
    return DateTime.utc(monday.year, monday.month, monday.day, 0, 0, 0);
  }
  DateTime _endOfWeekUtc() {
    final mon = _startOfWeekUtc();
    final sun = mon.add(const Duration(days: 6));
    return DateTime.utc(sun.year, sun.month, sun.day, 23, 59, 59);
  }

  // ===== Endpoints =====
  Future<List<Map<String, dynamic>>> getCategorySummary({required String start, required String end}) async {
    final res = await _dio.get('/api/sales/category', queryParameters: { 'start': start, 'end': end });
    final list = List<Map<String, dynamic>>.from(res.data['data'] ?? const []);
    return list;
  }

  Future<List<Map<String, dynamic>>> getBestsellers({required String start, required String end, int limit = 3}) async {
    final res = await _dio.get('/api/sales/bestsellers', queryParameters: { 'start': start, 'end': end, 'limit': limit });
    final list = List<Map<String, dynamic>>.from(res.data['data'] ?? const []);
    return list;
  }

  Future<Map<String, dynamic>> getProfitability({required String start, required String end, double rate = 0.7}) async {
    final res = await _dio.get('/api/sales/profitability', queryParameters: { 'start': start, 'end': end, 'rate': rate });
    return Map<String, dynamic>.from(res.data['data'] ?? {});
  }

  Future<List<Map<String, dynamic>>> getTimeOfDay({required String start, required String end}) async {
    final res = await _dio.get('/api/sales/time-of-day', queryParameters: { 'start': start, 'end': end });
    return List<Map<String, dynamic>>.from(res.data['data'] ?? const []);
  }

  Future<List<Map<String, dynamic>>> getWeekday({required String start, required String end}) async {
    final res = await _dio.get('/api/sales/weekday', queryParameters: { 'start': start, 'end': end });
    return List<Map<String, dynamic>>.from(res.data['data'] ?? const []);
  }

  Future<Map<String, dynamic>> getHighlights({required String start, required String end}) async {
    final res = await _dio.get('/api/sales/highlights', queryParameters: { 'start': start, 'end': end });
    return Map<String, dynamic>.from(res.data['data'] ?? {});
  }

  // ===== 추가: 월 요약 / 주차별 매출 =====
  Future<Map<String, dynamic>> getMonthSummary({required int year, required int month}) async {
    final res = await _dio.get('/api/sales/month-summary', queryParameters: { 'year': year, 'month': month });
    return Map<String, dynamic>.from(res.data['data'] ?? {});
  }

  Future<List<double>> getWeeklyByMonth({required int year, required int month}) async {
    final res = await _dio.get('/api/sales/weekly-by-month', queryParameters: { 'year': year, 'month': month });
    final data = Map<String, dynamic>.from(res.data['data'] ?? {});
    final rawWeeks = data['weeks'] ?? const [];
    final List<double> totals = [];
    if (rawWeeks is List) {
      for (final item in rawWeeks) {
        if (item is Map) {
          final total = item['total'];
          if (total is num) {
            totals.add(total.toDouble());
          } else {
            totals.add(0.0);
          }
        } else {
          totals.add(0.0);
        }
      }
    }
    return totals;
  }

  // ===== 보조 합계 =====
  Future<int> getTodayTotal() async {
    final start = _toUtcIso(_startOfTodayUtc());
    final end = _toUtcIso(_endOfTodayUtc());
    final res = await _dio.get('/api/sales/time-of-day', queryParameters: { 'start': start, 'end': end });
    final list = List<Map<String, dynamic>>.from(res.data['data'] ?? const []);
    final sum = list.fold<int>(0, (s, e) => s + ((e['total'] ?? 0) as int));
    return sum;
  }

  Future<int> getWeekTotal() async {
    final start = _toUtcIso(_startOfWeekUtc());
    final end = _toUtcIso(_endOfWeekUtc());
    final res = await _dio.get('/api/sales/weekday', queryParameters: { 'start': start, 'end': end });
    final list = List<Map<String, dynamic>>.from(res.data['data'] ?? const []);
    final sum = list.fold<int>(0, (s, e) => s + ((e['total'] ?? 0) as int));
    return sum;
  }

  // ===== 월별 시계열 =====
  Future<List<Map<String, dynamic>>> getMonthly({required String start, required String end}) async {
    final res = await _dio.get('/api/sales/monthly', queryParameters: { 'start': start, 'end': end });
    return List<Map<String, dynamic>>.from(res.data['data'] ?? const []);
  }

  // ===== CSV 업로드 =====
  Future<Map<String, dynamic>> uploadCsv(String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: filePath.split('/').last),
    });
    final res = await _dio.post(
      '/api/sales/upload',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    return Map<String, dynamic>.from(res.data ?? {});
  }

  // 바이트로 CSV 업로드 (웹/모바일 안전)
  Future<Map<String, dynamic>> uploadCsvBytes(List<int> bytes, String filename) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: filename),
    });
    final res = await _dio.post(
      '/api/sales/upload',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    return Map<String, dynamic>.from(res.data ?? {});
  }
}


