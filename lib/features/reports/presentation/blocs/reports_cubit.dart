import 'package:excel/excel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/data/sql/sqlfilte_ffi_consumer.dart';
import 'package:pscorner/core/helper/functions.dart';
import 'package:pscorner/features/reports/domain/usecases/export_file_use_case.dart';
import 'package:pscorner/features/reports/domain/usecases/get_table_directory_use_case.dart';
import 'package:pscorner/features/reports/domain/usecases/import_file_use_case.dart';
import 'reports_state.dart';

class ReportsBloc extends Cubit<ReportsState> {
  ReportsBloc(this._exportFileUseCase, this._importFileUseCase, this._getTableDirectoryUseCase)
      : super(const ReportsState());
  final ExportFileUseCase _exportFileUseCase;
  final ImportFileUseCase _importFileUseCase;
  final GetTableDirectoryUseCase _getTableDirectoryUseCase;

  Future<void> getTableDirectory(String tableName) async {
    final result = await _getTableDirectoryUseCase(tableName);
    result.fold((left) {
      emit(state.copyWith(
          status: ReportsStateStatus.error, errorMessage: left.message));
    }, (right) {
      emit(state.copyWith(status: ReportsStateStatus.success));
    });
  }

  Future<void> exportToFile(
      {required String filePath, required String table}) async {
    final result = await _exportFileUseCase(
        BackupParams(filePath: filePath, table: table));
    result.fold((left) {
      loggerError(left.message);
      emit(state.copyWith(
          status: ReportsStateStatus.error, errorMessage: left.message));
    }, (right) {
      loggerWarn('exported');
      emit(state.copyWith(status: ReportsStateStatus.success));
    });
  }

  Future<void> importFromFile(
      {required String filePath, required String table,required Map<String, dynamic> Function(List<Data?> row)? rowMapper}) async {
    final result = await _importFileUseCase(
        BackupParams(filePath: filePath, table: table,rowMapper: rowMapper));
    result.fold((left) {
      emit(state.copyWith(
          status: ReportsStateStatus.error, errorMessage: left.message));
    }, (right) {
      emit(state.copyWith(status: ReportsStateStatus.success));
    });
  }
}
