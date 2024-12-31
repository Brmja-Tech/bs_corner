import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/extensions/string_extension.dart';
import 'package:pscorner/core/helper/functions.dart';
import 'package:pscorner/features/shifts/data/datasources/shifts_data_source.dart';
import 'package:pscorner/features/shifts/data/models/shift_model.dart';
import 'package:pscorner/features/shifts/domain/usecases/delete_shift_use_case.dart';
import 'package:pscorner/features/shifts/domain/usecases/fetch_all_shifts_use_case.dart';
import 'package:pscorner/features/shifts/domain/usecases/insert_shift_use_case.dart';
import 'package:pscorner/features/shifts/domain/usecases/update_shift_use_case.dart';
import 'shifts_state.dart';

class ShiftsBloc extends Cubit<ShiftsState> {
  ShiftsBloc(this._insertShiftUseCase, this._fetchAllShiftsUseCase,
      this._updateShiftUseCase, this._deleteShiftUseCase)
      : super(const ShiftsState()) {
    fetchAllShifts();
  }

  final InsertShiftUseCase _insertShiftUseCase;
  final FetchAllShiftsUseCase _fetchAllShiftsUseCase;
  final UpdateShiftUseCase _updateShiftUseCase;
  final DeleteShiftUseCase _deleteShiftUseCase;

  Future<void> insertShift(
      {required String userId,
      required String userName,
      required double totalCollectedMoney,
      required String fromTime,
      required String toTime}) async {
    emit(state.copyWith(status: ShiftsStateStatus.loading));
    final result = await _insertShiftUseCase(InsertShiftParams(
        totalCollectedMoney: totalCollectedMoney,
        fromTime: DateTime.parse(fromTime),
        toTime: DateTime.parse(toTime),
        userId: userId,
        userName: userName));
    result.fold(
      (l) {
        loggerError('Failed to insert shift: ${l.message}');
        emit(state.copyWith(
            status: ShiftsStateStatus.error, errorMessage: l.message));
      },
      (r) {
        final shift = ShiftModel(
          id: r,
          startTime: fromTime.toDateTime,
          endTime: toTime.toDateTime,
          userId: userId,
          totalCollectedMoney: totalCollectedMoney,
          shiftUserName: userName,
        );
        emit(state.copyWith(
            status: ShiftsStateStatus.success,
            shifts: [shift ,...state.shifts]));
      },
    );
  }

  Future<void> fetchAllShifts() async {
    emit(state.copyWith(status: ShiftsStateStatus.loading));
    final result = await _fetchAllShiftsUseCase(const NoParams());
    result.fold(
      (l) {
        loggerError('Failed to fetch all shifts: ${l.message}');
        emit(state.copyWith(
            status: ShiftsStateStatus.error, errorMessage: l.message));
      },
      (r) {
        emit(state.copyWith(status: ShiftsStateStatus.success, shifts: r));
      },
    );
  }

  Future<void> updateShift(
      {required int shiftId,
      required int userId,
      required double totalCollectedMoney,
      required String fromTime,
      required String toTime}) async {
    emit(state.copyWith(status: ShiftsStateStatus.loading));
    final result = await _updateShiftUseCase(UpdateShiftParams(
        id: shiftId,
        totalCollectedMoney: totalCollectedMoney,
        fromTime: DateTime.parse(fromTime),
        toTime: DateTime.parse(toTime),
        userId: userId));
    result.fold(
      (l) => emit(state.copyWith(
          status: ShiftsStateStatus.error, errorMessage: l.message)),
      (r) => emit(state.copyWith(status: ShiftsStateStatus.success)),
    );
  }

  Future<void> deleteShift({required int shiftId}) async {
    emit(state.copyWith(status: ShiftsStateStatus.loading));
    final result = await _deleteShiftUseCase(shiftId);
    result.fold(
      (l) => emit(state.copyWith(
          status: ShiftsStateStatus.error, errorMessage: l.message)),
      (r) => emit(state.copyWith(status: ShiftsStateStatus.success)),
    );
  }
}
