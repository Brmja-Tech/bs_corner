import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/timers/data/datasources/timers_data_source.dart';
import 'timers_state.dart';

class TimersCubit extends Cubit<TimersState> {
  final TimersDataSource _timersDataSource;
  TimersCubit(this._timersDataSource) : super(TimersState());
  Future<Either<Failure, String>> startTimer({required String roomId}) async {
    emit(TimersLoading());
    return _timersDataSource.insertATimer(roomId: roomId).then((value) {
      return value.fold((l) {
        emit(TimerFailure(l.message));
        return Left(l);
      }, (r) {
        emit(TimerSuccess(r));

        return Right(r);
      });
    });
  }

  Future<Either<Failure, String>> stopTimer({required String roomId}) async {
    emit(TimersLoading());
    return _timersDataSource.stopAtimer(roomId: roomId).then((value) {
      return value.fold((l) {
        emit(TimerFailure(l.message));
        return Left(l);
      }, (r) {
        emit(TimerSuccess(r));
        return Right(r);
      });
    });
  }
}
