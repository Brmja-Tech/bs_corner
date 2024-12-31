// import 'package:flutter/material.dart';
// import 'package:pscorner/core/dummy/dummy_list_items.dart';
// import 'package:pscorner/core/ui/item.dart';
//
// class ItemsGrid extends StatelessWidget {
//   const ItemsGrid({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GridView(
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 11, // Number of items per row
//         mainAxisSpacing: 10, // Space between rows
//         crossAxisSpacing: 10, // Space between columns
//         childAspectRatio: 1, // Width to height ratio
//         mainAxisExtent: 80, // Fixed height for each item
//       ),
//       children: [
//         ...dummyItems.map((item) => Item(name: item, color: Colors.blue)),
//       ],
//     );
//   }
// }
