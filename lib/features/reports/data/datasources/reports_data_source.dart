import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/sql/sqlfilte_ffi_consumer.dart';
import 'package:pscorner/core/data/utils/either.dart';

abstract class ReportsDataSource {
  Future<Either<Failure, void>> exportToFile(BackupParams params);

  Future<Either<Failure, void>> importFromFile(BackupParams params);
}

class ReportsDataSourceImpl implements ReportsDataSource {
  final SQLFLiteFFIConsumer _dbConsumer;

  ReportsDataSourceImpl(this._dbConsumer);

  @override
  Future<Either<Failure, void>> exportToFile(BackupParams params) async {
    try {
      final result = await _dbConsumer.exportToExcelFile(params);
      return result.fold(
        (failure) => Left(failure),
        (_) => Right(null),
      );
    } catch (e) {
      return Left(CreateFailure(message: 'Failed to export data: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> importFromFile(BackupParams params) async {
    try {
      final result = await _dbConsumer.importToExcel(params);
      return result.fold(
        (failure) => Left(failure),
        (_) => Right(null),
      );
    } catch (e) {
      return Left(CreateFailure(message: 'Failed to import data: $e'));
    }
  }
}
