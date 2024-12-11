import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/data/sql/sqlfilte_ffi_consumer.dart';
import 'package:pscorner/core/helper/functions.dart';
import 'package:pscorner/core/stateless/custom_button.dart';
import 'package:pscorner/core/stateless/gaps.dart';
import 'package:pscorner/core/stateless/label.dart';
import 'package:pscorner/core/stateless/responsive_scaffold.dart';
import 'package:pscorner/features/reports/data/repositories/tables.dart';
import 'package:pscorner/features/reports/presentation/blocs/reports_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      desktopBody: Center(
          child: Row(
        children: [
          CustomButton(
              text: 'استخراج بيانات الموظفين',
              onPressed: () async {
                await _exportFile(context, Tables.users);
              }),
          AppGaps.gap28Horizontal,
          CustomButton(
              text: 'توريد بيانات الموظفين',
              onPressed: () async {
                await _importFile(context, Tables.users, (row) {
                  // Validate required fields
                  if (row[0]?.value == null || row[1]?.value == null) {
                    throw Exception('Invalid data in row');
                  }

                  // Convert all cell values to supported SQLite types
                  return {
                    "id": row[0]?.value is String || row[0]?.value is num
                        ? row[0]?.value.toString()
                        : null,
                    // Ensure ID is always a String (or null if invalid)
                    "username": row[1]?.value.toString(),
                    // Convert to String
                    "password":
                        row[2]?.value != null ? row[2]?.value.toString() : '',
                    // Default password to an empty string if null
                  };
                });
              }),
        ],
      )),
    );
  }

  Future<void> _exportFile(BuildContext context, String table) async {
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

  Future<void> _importFile(
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
}
