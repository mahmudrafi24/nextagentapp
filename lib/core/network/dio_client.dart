import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class DioClient {
  DioClient._();

  static Dio createDio(String apiKey) {
    final dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: ApiConstants.timeoutSeconds),
      receiveTimeout:
          const Duration(seconds: ApiConstants.receiveTimeoutSeconds),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': ApiConstants.anthropicVersion,
      },
    ));

    dio.interceptors.addAll([
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => developer.log('$obj', name: 'DIO'),
      ),
    ]);

    return dio;
  }

  static void updateApiKey(Dio dio, String apiKey) {
    dio.options.headers['x-api-key'] = apiKey;
  }
}
