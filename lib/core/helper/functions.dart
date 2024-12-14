import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:pscorner/features/reports/presentation/blocs/reports_cubit.dart';

navTo(BuildContext context, Widget widget, {String? routeName}) =>
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => widget,
        settings: RouteSettings(
          name: routeName,
        )));

navToAndRemoveUntil(BuildContext context, Widget widget, {String? routeName}) =>
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (context) => widget,
          settings: RouteSettings(name: routeName)),
          (route) => false,
    );
Map<String, Widget Function(BuildContext)> routes = {

};
final RegExp numberRegex = RegExp(r'^\d+(\.\d+)?$');

void logger(message) => Logger().d(message);

void loggerError(message) => Logger().e(message);

void loggerWarn(message) => Logger().w(message);


Future<void> exportExcelFile(BuildContext context, String table) async {
  String? selectedPath = await FilePicker.platform.saveFile(
    dialogTitle: 'Select Export File Location',
    fileName: 'employees_data.xlsx', // Suggest a default file name
  );

  if (selectedPath != null) {
    context.read<ReportsBloc>().exportToFile(
      filePath: selectedPath,
      table: table,
    );
  } else {
    // User canceled the file picker
    logger('No path selected');
  }
}

Future<void> importExcelFile(
    BuildContext context,
    String table,
    Map<String, dynamic> Function(List<Data?> row) rowMapper,
    ) async {
  // Open file picker to select an Excel file
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['xlsx'], // Restrict to Excel files
  );

  if (result != null) {
    // Get the selected file path
    String filePath = result.files.single.path!;

    // Use the ReportsBloc to import data with the provided mapper
    await context.read<ReportsBloc>().importFromFile(
      filePath: filePath,
      table: table,
      rowMapper: rowMapper, // Pass the mapper function
    );
  }
}