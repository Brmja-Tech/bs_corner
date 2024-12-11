import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/sql/sqlfilte_ffi_consumer.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/reports/domain/repositories/reports_repository.dart';

class ImportFileUseCase extends BaseUseCase<void,BackupParams>{
  final ReportsRepository _reportsRepository;

  ImportFileUseCase(this._reportsRepository);

  @override
  Future<Either<Failure, void>> call(BackupParams params) async {
    return await _reportsRepository.importFromFile(params);
  }
}