import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

Dio buildDio() {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com', 
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    responseType: ResponseType.json,
    headers: {'Accept': 'application/json'},
  ));

  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(
      requestBody: false,
      responseBody: false,
      requestHeader: false,
      responseHeader: false,
      logPrint: (o) => debugPrint(o.toString()),
    ));
  }
  return dio;
}



