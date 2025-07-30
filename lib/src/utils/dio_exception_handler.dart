import 'package:dio/dio.dart';

class DioExceptionHandler {
  static String getMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionTimeout:
        return 'Connection problem. Please check your internet and try again.';
      case DioExceptionType.badResponse:
        // You could add more specific handling based on e.response.statusCode here
        return 'The server returned an error. Please try again later.';
      case DioExceptionType.cancel:
        return 'The request was cancelled.';
      case DioExceptionType.unknown:
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}