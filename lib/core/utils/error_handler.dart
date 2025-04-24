import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../error/failures.dart';
import '../services/logger_service.dart';

/// A utility class for handling errors
class ErrorHandler {
  /// The logger service
  final LoggerService _logger = GetIt.instance<LoggerService>();

  /// Handles an exception and returns a failure
  Failure handleException(Object exception, StackTrace stackTrace) {
    _logger.e('Exception caught: $exception', exception, stackTrace);

    if (exception is SocketException) {
      return NetworkFailure(
        message: 'No internet connection',
        errorType: NetworkErrorType.noInternet,
        stackTrace: stackTrace,
      );
    } else if (exception is TimeoutException) {
      return TimeoutFailure(
        message: 'Request timed out',
        duration: exception.duration,
        stackTrace: stackTrace,
      );
    } else if (exception is FormatException) {
      return FormatFailure(
        message: 'Invalid format: ${exception.message}',
        input: exception.source?.toString(),
        stackTrace: stackTrace,
      );
    } else {
      return UnexpectedFailure(
        message: 'An unexpected error occurred: ${exception.toString()}',
        stackTrace: stackTrace,
      );
    }
  }

  /// Runs a function with error handling
  Future<Either<Failure, T>> runWithErrorHandling<T>(
    Future<T> Function() function,
  ) async {
    try {
      final result = await function();
      return Right(result);
    } catch (e, stackTrace) {
      return Left(handleException(e, stackTrace));
    }
  }

  /// Shows an error snackbar
  void showErrorSnackBar(BuildContext context, Failure failure) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(failure.message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Logs a failure
  void logFailure(Failure failure) {
    _logger.e(
      'Failure: ${failure.runtimeType} - ${failure.message}',
      failure,
      failure.stackTrace,
    );
  }
}
