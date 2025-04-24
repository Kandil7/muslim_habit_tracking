import 'package:flutter/material.dart';

import '../../error/failures.dart';
import '../../localization/app_localizations_extension.dart';
import '../../theme/app_theme.dart';

/// Shows an error dialog
Future<void> showErrorDialog({
  required BuildContext context,
  required Failure failure,
  String? title,
  VoidCallback? onRetry,
  bool showRetry = true,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(
          title ?? _getTitleForFailure(failure, context),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                failure.message,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (failure is ValidationFailure && failure.fieldErrors != null) ...[
                const SizedBox(height: 16),
                ..._buildValidationErrors(failure, context),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: Text(context.tr.translate('common.close')),
          ),
          if (showRetry && onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onRetry();
              },
              child: Text(context.tr.translate('common.retry')),
            ),
        ],
        icon: Icon(
          _getIconForFailure(failure),
          color: _getColorForFailure(failure),
          size: 36,
        ),
      );
    },
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

/// Builds validation error widgets
List<Widget> _buildValidationErrors(ValidationFailure failure, BuildContext context) {
  final errors = failure.fieldErrors!;
  return errors.entries.map((entry) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline,
            size: 16,
            color: AppColors.warning,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${entry.key}: ${entry.value}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }).toList();
}
