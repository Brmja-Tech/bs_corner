import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/sql/sqlfilte_ffi_consumer.dart';
import 'package:pscorner/core/data/utils/either.dart';

abstract class ReportsRepository {
  Future<Either<Failure, void>> exportToFile(BackupParams params);

  Future<Either<Failure, void>> importFromFile(BackupParams params);
  Future<Either<Failure,String>> getDatabasePath(String databaseName);
}
