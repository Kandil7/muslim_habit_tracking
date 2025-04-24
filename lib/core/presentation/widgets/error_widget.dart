import 'package:flutter/material.dart';

import '../../error/failures.dart';
import '../../localization/app_localizations_extension.dart';
import '../../theme/app_theme.dart';

/// A reusable widget for displaying errors with retry functionality
class AppErrorWidget extends StatelessWidget {
  /// The failure to display
  final Failure failure;

  /// The retry callback
  final VoidCallback? onRetry;

  /// Whether to show a retry button
  final bool showRetry;

  /// Additional message to display
  final String? additionalMessage;

  /// Icon to display
  final IconData? icon;

  /// Creates an [AppErrorWidget]
  const AppErrorWidget({
    super.key,
    required this.failure,
    this.onRetry,
    this.showRetry = true,
    this.additionalMessage,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? _getIconForFailure(failure),
              size: 64,
              color: _getColorForFailure(failure),
            ),
            const SizedBox(height: 16),
            Text(
              _getTitleForFailure(failure, context),
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              failure.message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (additionalMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                additionalMessage!,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
            if (showRetry && onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(context.tr.translate('common.retry')),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Returns the appropriate icon for the failure
  IconData _getIconForFailure(Failure failure) {
    if (failure is NetworkFailure) {
      return Icons.wifi_off;
    } else if (failure is ServerFailure) {
      return Icons.cloud_off;
    } else if (failure is CacheFailure) {
      return Icons.storage;
    } else if (failure is AuthFailure) {
      return Icons.lock;
    } else if (failure is PermissionFailure) {
      return Icons.no_accounts;
    } else if (failure is ValidationFailure) {
      return Icons.error_outline;
    } else if (failure is LocationFailure) {
      return Icons.location_off;
    } else if (failure is TimeoutFailure) {
      return Icons.timer_off;
    } else if (failure is ResourceNotFoundFailure) {
      return Icons.search_off;
    } else if (failure is FeatureNotAvailableFailure) {
      return Icons.not_interested;
    } else {
      return Icons.error_outline;
    }
  }

  /// Returns the appropriate color for the failure
  Color _getColorForFailure(Failure failure) {
    if (failure is NetworkFailure) {
      return AppColors.warning;
    } else if (failure is ServerFailure) {
      return AppColors.error;
    } else if (failure is CacheFailure) {
      return AppColors.warning;
    } else if (failure is AuthFailure) {
      return AppColors.error;
    } else if (failure is PermissionFailure) {
      return AppColors.warning;
    } else if (failure is ValidationFailure) {
      return AppColors.warning;
    } else if (failure is LocationFailure) {
      return AppColors.warning;
    } else if (failure is TimeoutFailure) {
      return AppColors.warning;
    } else if (failure is ResourceNotFoundFailure) {
      return AppColors.warning;
    } else if (failure is FeatureNotAvailableFailure) {
      return AppColors.warning;
    } else {
      return AppColors.error;
    }
  }

  /// Returns the appropriate title for the failure
  String _getTitleForFailure(Failure failure, BuildContext context) {
    if (failure is NetworkFailure) {
      return context.tr.translate('error.network');
    } else if (failure is ServerFailure) {
      return context.tr.translate('error.server');
    } else if (failure is CacheFailure) {
      return context.tr.translate('error.cache');
    } else if (failure is AuthFailure) {
      return context.tr.translate('error.auth');
    } else if (failure is PermissionFailure) {
      return context.tr.translate('error.permission');
    } else if (failure is ValidationFailure) {
      return context.tr.translate('error.validation');
    } else if (failure is LocationFailure) {
      return context.tr.translate('error.location');
    } else if (failure is TimeoutFailure) {
      return context.tr.translate('error.timeout');
    } else if (failure is ResourceNotFoundFailure) {
      return context.tr.translate('error.notFound');
    } else if (failure is FeatureNotAvailableFailure) {
      return context.tr.translate('error.featureNotAvailable');
    } else {
      return context.tr.translate('error.unknown');
    }
  }
}
