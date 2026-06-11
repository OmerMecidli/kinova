import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters['api_key'] = ApiConstants.apiKey;
    
    super.onRequest(options, handler);
  }
}