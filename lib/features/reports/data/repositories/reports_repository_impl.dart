import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/sql/sqlfilte_ffi_consumer.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/reports/data/datasources/reports_data_source.dart';

import '../../domain/repositories/reports_repository.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsDataSource _reportsDataSource;
  final SQLFLiteFFIConsumer _sqlfLiteFFIConsumer;

  ReportsRepositoryImpl(this._reportsDataSource, this._sqlfLiteFFIConsumer);

  @override
  Future<Either<Failure, void>> exportToFile(BackupParams params) =>
      _reportsDataSource.exportToFile(params);

  @override
  Future<Either<Failure, void>> importFromFile(BackupParams params) =>
      _reportsDataSource.importFromFile(params);

  @override
  Future<Either<Failure, String>> getDatabasePath(String databaseName) =>
      _sqlfLiteFFIConsumer.getDatabasePath(databaseName);
}
