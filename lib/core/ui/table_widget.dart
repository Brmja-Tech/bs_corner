import 'package:flutter/material.dart';

class TableWidget extends StatelessWidget {
  const TableWidget({super.key, this.rows, this.columns});

  final List<DataRow>? rows;
  final List<DataColumn>? columns;

  @override
  Widget build(BuildContext context) {
    const BorderSide borderSide =
        BorderSide(color: Color(0xffF4E3E3), width: 2);
    // const BorderSide borderSideGrey = BorderSide(color: Color.fromARGB(255, 192, 192, 192), width: .3);

    return SingleChildScrollView(
      child: DataTable(
        headingTextStyle: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        dataTextStyle: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
        headingRowColor: const WidgetStatePropertyAll(Color(0xff5D7285)),
        dataRowMinHeight: 50,
        dataRowMaxHeight: 100,
        border: const TableBorder(
          top: borderSide,
          bottom: borderSide,
          left: borderSide,
          right: borderSide,
          horizontalInside: borderSide,
          verticalInside: borderSide,
        ),
        columns: columns ?? [],
        rows: rows ?? [],
      ),
    );
  }
}
