import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/analytics_repository.dart';

/// Parameters for the ExportAnalyticsData use case
class ExportAnalyticsDataParams {
  /// The format to export (csv, pdf)
  final String format;

  /// Constructor
  const ExportAnalyticsDataParams({required this.format});
}

/// Use case for exporting analytics data
class ExportAnalyticsData implements UseCase<String, ExportAnalyticsDataParams> {
  final AnalyticsRepository repository;

  /// Constructor
  const ExportAnalyticsData(this.repository);

  @override
  Future<Either<Failure, String>> call(ExportAnalyticsDataParams params) async {
    return await repository.exportAnalyticsData(params.format);
  }
}
