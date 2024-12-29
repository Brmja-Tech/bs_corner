import 'package:flutter/material.dart';

class ItemsConsumedView extends StatelessWidget {
  const ItemsConsumedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      constraints: const BoxConstraints(maxHeight: 500),
      child: DataTable(
        columns: const [
          DataColumn(
            label: Text(
              'اسم المنتج',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'الكميه',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'العدد',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'السعر',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'الاجمالي',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
        rows: const [
          DataRow(
            cells: [
              DataCell(
                Text(
                  'منتج 1',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              DataCell(
                Text(
                  '5',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              DataCell(
                Text(
                  '50',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              DataCell(
                Text(
                  '100',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              DataCell(
                Text(
                  '500',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
