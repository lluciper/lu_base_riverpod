import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../resources/generated/l10n.dart';


class ErrorHelper {
  ErrorHelper._();

  static String getError(BuildContext context, Object? error) {
    var errorMessage = '';
    final unknownError = S.current.unknown_error;
    if (error is DioException) {
      final type = error.type;
      if (type case DioExceptionType.connectionTimeout) {
        errorMessage = S.current.timeout_error;
      } else if (type case DioExceptionType.connectionError) {
        errorMessage = S.current.network_error;
      } else {
        errorMessage = S.current.unknown_error;
      }
    } else if (error is Exception) {
      errorMessage = error.toString();
    } else {
      errorMessage = unknownError;
    }
    return errorMessage;
  }
}
