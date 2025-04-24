import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../error/failures.dart';
import '../services/logger_service.dart';
import 'network_info.dart';

/// A utility class for handling network errors
class NetworkErrorHandler {
  /// The network info
  final NetworkInfo networkInfo;

  /// The logger service
  final LoggerService _logger = GetIt.instance<LoggerService>();

  /// Creates a [NetworkErrorHandler]
  NetworkErrorHandler({required this.networkInfo});

  /// Handles a network request with error handling
  Future<Either<Failure, T>> handleNetworkRequest<T>({
    required Future<T> Function() request,
    required String requestName,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await request();
        return Right(result);
      } on SocketException catch (e, stackTrace) {
        _logger.e(
          'SocketException in $requestName: ${e.message}',
          e,
          stackTrace,
        );
        return Left(
          NetworkFailure(
            message: 'No internet connection',
            errorType: NetworkErrorType.noInternet,
            stackTrace: stackTrace,
          ),
        );
      } on http.ClientException catch (e, stackTrace) {
        _logger.e(
          'ClientException in $requestName: ${e.message}',
          e,
          stackTrace,
        );
        return Left(
          NetworkFailure(
            message: 'Network error: ${e.message}',
            errorType: NetworkErrorType.badResponse,
            stackTrace: stackTrace,
          ),
        );
      } on FormatException catch (e, stackTrace) {
        _logger.e(
          'FormatException in $requestName: ${e.message}',
          e,
          stackTrace,
        );
        return Left(
          FormatFailure(
            message: 'Invalid response format: ${e.message}',
            input: e.source?.toString(),
            stackTrace: stackTrace,
          ),
        );
      } on TimeoutException catch (e, stackTrace) {
        _logger.e('TimeoutException in $requestName', e, stackTrace);
        return Left(
          TimeoutFailure(
            message: 'Request timed out',
            duration: e.duration,
            stackTrace: stackTrace,
          ),
        );
      } catch (e, stackTrace) {
        _logger.e('Unexpected error in $requestName: $e', e, stackTrace);
        return Left(
          ServerFailure(
            message: 'Server error: ${e.toString()}',
            stackTrace: stackTrace,
          ),
        );
      }
    } else {
      _logger.w('No internet connection for $requestName');
      return Left(
        NetworkFailure(
          message: 'No internet connection',
          errorType: NetworkErrorType.noInternet,
        ),
      );
    }
  }

  /// Handles an HTTP response
  Either<Failure, T> handleResponse<T>({
    required http.Response response,
    required T Function(http.Response) onSuccess,
    required String requestName,
  }) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return Right(onSuccess(response));
      } on FormatException catch (e, stackTrace) {
        _logger.e(
          'FormatException in $requestName: ${e.message}',
          e,
          stackTrace,
        );
        return Left(
          FormatFailure(
            message: 'Invalid response format: ${e.message}',
            input: e.source?.toString(),
            stackTrace: stackTrace,
          ),
        );
      } catch (e, stackTrace) {
        _logger.e(
          'Error processing response in $requestName: $e',
          e,
          stackTrace,
        );
        return Left(
          ServerFailure(
            message: 'Error processing response: ${e.toString()}',
            stackTrace: stackTrace,
          ),
        );
      }
    } else {
      _logger.e(
        'HTTP error in $requestName: ${response.statusCode} - ${response.reasonPhrase}',
        response.body,
      );
      return Left(
        ServerFailure(
          message: 'Server error: ${response.reasonPhrase}',
          statusCode: response.statusCode,
        ),
      );
    }
  }
}
