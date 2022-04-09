import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

Dio api() {
  return Dio(
    BaseOptions(
        connectTimeout: 5000,
        receiveTimeout: 5000,
        baseUrl: "ccapi12.herokuapp.com"),
  )..interceptors.add(AppInterceptor());
}

class AppInterceptor extends Interceptor {
  static String? token;
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (token != null) {
      options.headers['Authorization'] = "Bearer $token";
    }
    super.onRequest(options, handler);
  }
}
