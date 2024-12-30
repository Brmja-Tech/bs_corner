import 'package:get_it/get_it.dart';
import 'package:pscorner/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:pscorner/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:pscorner/features/auth/domain/repositories/auth_repository.dart';
import 'package:pscorner/features/auth/domain/usecases/login_use_case.dart';
import 'package:pscorner/features/auth/domain/usecases/register_use_case.dart';
import 'package:pscorner/features/auth/presentation/blocs/auth_cubit.dart';

class AuthLocalServiceLocator {
  static Future<void> execute({required GetIt sl}) async {
    sl.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(sl(),sl()));
    sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
    sl.registerFactory(() => LoginUseCase(sl()));
    sl.registerFactory(() => RegisterUseCase(sl()));
    sl.registerLazySingleton<AuthBloc>(() => AuthBloc(sl(), sl()));
  }
}
