import 'package:get_it/get_it.dart';
import 'package:pscorner/features/reports/data/datasources/reports_data_source.dart';
import 'package:pscorner/features/reports/data/repositories/reports_repository_impl.dart';
import 'package:pscorner/features/reports/domain/repositories/reports_repository.dart';
import 'package:pscorner/features/reports/domain/usecases/export_file_use_case.dart';
import 'package:pscorner/features/reports/domain/usecases/get_table_directory_use_case.dart';
import 'package:pscorner/features/reports/domain/usecases/import_file_use_case.dart';
import 'package:pscorner/features/reports/presentation/blocs/reports_cubit.dart';

class ReportServiceLocator{

  static Future<void> execute({required GetIt sl}) async {
    sl.registerLazySingleton<ReportsDataSource>(() => ReportsDataSourceImpl(sl()));
    sl.registerLazySingleton<ReportsRepository>(() => ReportsRepositoryImpl(sl(),sl()));
    sl.registerFactory(() => ExportFileUseCase(sl()));
    sl.registerFactory(() => ImportFileUseCase(sl()));
    sl.registerFactory(() => GetTableDirectoryUseCase(sl()));
    sl.registerLazySingleton<ReportsBloc>(() => ReportsBloc(sl(),sl(),sl()));
  }
}