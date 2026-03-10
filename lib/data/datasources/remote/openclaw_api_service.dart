import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';

class OpenClawApiService {
  final Dio _dio;

  OpenClawApiService({required Dio dio}) : _dio = dio;

  Future<String> sendMessage({
    required List<Map<String, dynamic>> messages,
    String? systemPrompt,
    int maxTokens = ApiConstants.maxTokens,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.chatEndpoint,
        data: {
          'model': ApiConstants.model,
          'max_tokens': maxTokens,
          if (systemPrompt != null) 'system': systemPrompt,
          'messages': messages,
        },
      );

      final content = response.data['content'] as List;
      if (content.isEmpty) {
        throw const ServerException(message: 'Empty response from API');
      }
      return content[0]['text'] as String;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const ServerException(
            message: 'Request timed out. Please try again.');
      }
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final message = e.response!.data is Map
            ? (e.response!.data['error']?['message'] ?? 'API error occurred')
            : 'API error occurred';
        throw ServerException(
            message: message.toString(), statusCode: statusCode);
      }
      throw ServerException(message: e.message ?? 'Network error occurred');
    }
  }
}
