import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'api_interceptor.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json,
      ),
    );

    // Yaratdığımız Interceptor-u Dio-ya bağlayırıq
    _dio.interceptors.add(ApiInterceptor());
    
    // LogInterceptor: Terminalda gedən sorğuları və gələn cavabları (JSON) 
    // görmək üçün çox faydalıdır. Debugging-i xeyli asanlaşdırır.
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: false,
    ));
  }

  Dio get dio => _dio;
}