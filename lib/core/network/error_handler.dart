import 'package:dio/dio.dart';

class ErrorHandler {
  static String handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return "Bağlantı vaxtı bitdi. İnternetinizi yoxlayın.";
        case DioExceptionType.badResponse:
          return "Server xətası: ${error.response?.statusCode}";
        case DioExceptionType.connectionError:
          return "İnternet bağlantısı yoxdur.";
        default:
          return "Gözlənilməz bir şəbəkə xətası baş verdi.";
      }
    }
    return "Bilinməyən xəta baş verdi: $error";
  }
}