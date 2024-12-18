import 'package:get_it/get_it.dart';
import 'package:pscorner/features/rooms/data/datasources/rooms_data_source.dart';
import 'package:pscorner/features/rooms/data/repositories/rooms_repository_impl.dart';
import 'package:pscorner/features/rooms/domain/repositories/rooms_repository.dart';
import 'package:pscorner/features/rooms/domain/usecases/clear_room_table_use_case.dart';
import 'package:pscorner/features/rooms/domain/usecases/delete_room_use_case.dart';
import 'package:pscorner/features/rooms/domain/usecases/fetch_all_rooms_use_case.dart';
import 'package:pscorner/features/rooms/domain/usecases/insert_room_use_case.dart';
import 'package:pscorner/features/rooms/domain/usecases/update_room_use_case.dart';
import 'package:pscorner/features/rooms/presentation/blocs/rooms_cubit.dart';

class RoomsServiceLocator {
  static Future<void> execute({required GetIt sl}) async {
    sl.registerLazySingleton<RoomDataSource>(()=>RoomDataSourceImpl(sl()));
    sl.registerLazySingleton<RoomsRepository>(()=>RoomsRepositoryImpl(sl()));
    sl.registerFactory(()=> FetchAllRoomsUseCase(sl()));
    sl.registerFactory(()=> UpdateRoomUseCase(sl()));
    sl.registerFactory(()=> DeleteRoomUseCase(sl()));
    sl.registerFactory(()=> InsertRoomUseCase(sl()));
    sl.registerFactory(()=> ClearRoomTableUseCase(sl()));
    sl.registerLazySingleton(()=> RoomsBloc(sl(),sl(),sl(),sl(),sl()));
  }
}