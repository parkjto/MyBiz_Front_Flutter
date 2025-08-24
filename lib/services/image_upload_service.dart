import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageUploadService {
  // TODO: 실제 API 엔드포인트로 교체
  static const String baseUrl = 'https://your-api-endpoint.com';

  static const int maxImageSize = 10 * 1024 * 1024; // 10MB
  static const int maxImageCount = 5;
  static const List<String> allowedFormats = ['jpg', 'jpeg', 'png', 'webp'];

  final Dio _dio = Dio(
    BaseOptions(
      // 필요하면 baseUrl: '...' 로도 사용 가능
      // baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      validateStatus: (code) => code != null && code >= 200 && code < 300,
    ),
  );

  /// 갤러리 권한 요청 (iOS/Android 대응)
  Future<bool> requestGalleryPermission() async {
    if (Platform.isIOS) {
      final status = await Permission.photos.request();
      return status.isGranted;
    } else {
      // Android: OS 버전에 따라 storage 또는 photos(READ_MEDIA_IMAGES) 요청
      final photos = await Permission.photos.request();   // Android 13+
      final storage = await Permission.storage.request(); // Android 12-
      return photos.isGranted || storage.isGranted;
    }
  }

  /// 파일 확장자 검사
  bool isValidImageFormat(String filePath) {
    final ext = filePath.split('.').last.toLowerCase();
    return allowedFormats.contains(ext);
  }

  /// 원본 파일 크기 검사
  bool isValidImageSize(File file) => file.lengthSync() <= maxImageSize;

  /// 이미지 압축 (크면 1920px로 리사이즈 + JPEG 품질 압축)
  Future<File> compressImage(File file, {int quality = 85}) async {
    try {
      final bytes = await file.readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded == null) {
        throw Exception('이미지를 디코딩할 수 없습니다.');
      }

      img.Image result = decoded;
      if (decoded.width > 1920 || decoded.height > 1920) {
        // 긴 변 기준 1920 리사이즈
        if (decoded.width >= decoded.height) {
          result = img.copyResize(decoded, width: 1920);
        } else {
          result = img.copyResize(decoded, height: 1920);
        }
      }

      final compressedBytes = img.encodeJpg(result, quality: quality);

      final tempDir = await getTemporaryDirectory();
      final out = File(
        '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await out.writeAsBytes(compressedBytes, flush: true);
      return out;
    } catch (e) {
      throw Exception('이미지 압축 중 오류가 발생했습니다: $e');
    }
  }

  /// (내부) 서버 응답을 항상 Map<String,dynamic>으로 정규화
  Map<String, dynamic> _normalizeResponse(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is String && data.isNotEmpty) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) return decoded;
        return {'data': decoded};
      } catch (_) {
        // JSON이 아니면 문자열 자체를 감싸서 반환
        return {'message': data};
      }
    }
    return {'data': data};
  }

  /// 다중 이미지 업로드 (진행률 없음)
  Future<Map<String, dynamic>> uploadImages(List<File> images) async {
    return uploadImagesWithProgress(images, (_) {});
  }

  /// 다중 이미지 업로드 (진행률 콜백 포함)
  ///
  /// onProgress: 0.0 ~ 1.0
  Future<Map<String, dynamic>> uploadImagesWithProgress(
    List<File> images,
    void Function(double progress) onProgress,
  ) async {
    try {
      if (images.isEmpty) {
        throw Exception('업로드할 이미지를 선택해주세요.');
      }
      if (images.length > maxImageCount) {
        throw Exception('최대 $maxImageCount장까지 선택 가능합니다.');
      }

      // 전처리(형식/크기/압축) 진행률: 0 ~ 0.3
      final processed = <File>[];
      for (int i = 0; i < images.length; i++) {
        final f = images[i];

        if (!isValidImageFormat(f.path)) {
          throw Exception('지원하지 않는 이미지 형식입니다. (JPG, PNG, WEBP만 지원)');
        }

        if (!isValidImageSize(f)) {
          // 크면 압축 시도
          processed.add(await compressImage(f));
        } else {
          processed.add(f);
        }
        onProgress(((i + 1) / images.length) * 0.3);
      }

      // FormData 구성
      final formData = FormData();
      for (int i = 0; i < processed.length; i++) {
        formData.files.add(
          MapEntry(
            'images',
            await MultipartFile.fromFile(
              processed[i].path,
              filename: 'image_$i.jpg',
            ),
          ),
        );
      }

      // 업로드(0.3 ~ 0.9)
      final res = await _dio.post(
        '$baseUrl/analyze',
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
        onSendProgress: (sent, total) {
          if (total <= 0) {
            // total이 0인 경우 안전 처리
            onProgress(0.6); // 대략 중간값
          } else {
            final p = 0.3 + (sent / total) * 0.6;
            onProgress(p.clamp(0.0, 0.9));
          }
        },
      );

      // 완료(1.0)
      onProgress(1.0);

      return _normalizeResponse(res.data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('서버 연결 시간이 초과되었습니다.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('서버 응답 시간이 초과되었습니다.');
      } else if (e.response?.statusCode == 413) {
        throw Exception('업로드할 이미지가 너무 큽니다.');
      } else if (e.response?.statusCode == 400) {
        final msg = _extractMessage(e.response?.data);
        throw Exception('잘못된 요청입니다: $msg');
      } else if (e.response?.statusCode == 500) {
        throw Exception('서버 오류가 발생했습니다.');
      } else {
        throw Exception('업로드 중 오류가 발생했습니다: ${e.message}');
      }
    } catch (e) {
      throw Exception('알 수 없는 오류가 발생했습니다: $e');
    }
  }

  String _extractMessage(dynamic data) {
    try {
      final norm = _normalizeResponse(data);
      final msg = norm['message'];
      return msg is String ? msg : '';
    } catch (_) {
      return '';
    }
  }
}
