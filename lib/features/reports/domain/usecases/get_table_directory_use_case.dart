import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/reports/domain/repositories/reports_repository.dart';

class GetTableDirectoryUseCase extends BaseUseCase<String, String> {
  final ReportsRepository repository;

  GetTableDirectoryUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(String params) async {
    return await repository.getDatabasePath(params);
  }
}
