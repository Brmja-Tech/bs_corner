import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/extensions/context_extension.dart';
import 'package:pscorner/core/extensions/string_extension.dart';
import 'package:pscorner/core/stateless/custom_button.dart';
import 'package:pscorner/core/stateless/custom_scaffold.dart';
import 'package:pscorner/core/stateless/label.dart';
import 'package:pscorner/core/ui/table_widget.dart';
import 'package:pscorner/features/recipes/presentation/blocs/recipes_cubit.dart';
import 'package:pscorner/features/recipes/presentation/blocs/recipes_state.dart';
import 'package:pscorner/features/recipes/presentation/widgets/add_recipe_screen.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      selectedIndex: 5,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              alignment: AlignmentDirectional.centerEnd,
              text: 'اضافه منتج جديد',
              onPressed: () {
                context.go(const AddRecipeScreen());
              },
              width: context.width * 0.2,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            ),
          ),
          BlocBuilder<RecipesBloc, RecipesState>(
            builder: (context, state) {
              if (state.recipes.isEmpty) {
                return Expanded(
                    child: Center(
                        child: Label(
                  text: 'لا يوجد منتجات',
                  style: context.appTextTheme.titleLarge,
                )));
              }
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  children: [
                    if (state.isLoading) const LinearProgressIndicator(),
                    SizedBox(
                      height: context.height * 0.6,
                      width: double.infinity,
                      child: TableWidget(
                        columns: [
                          DataColumn(
                            label: Text(
                              'اسم المنتج',
                              overflow: TextOverflow.ellipsis,
                              style: context.appTextTheme.headlineSmall,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'نوع المنتج',
                              style: context.appTextTheme.headlineSmall,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'الوزن',
                              style: context.appTextTheme.headlineSmall,
                            ),
                          ),
                          DataColumn(
                            label: Label(
                              text: 'الاجراءات',
                              style: context.appTextTheme.headlineSmall,
                            ),
                          ),
                        ],
                        rows: state.recipes.map((item) {
                          return DataRow(cells: [
                            DataCell(Label(
                              text: item['name'] ?? '',
                              // Access 'name' from the map
                              style: context.appTextTheme.headlineSmall,
                            )),
                            DataCell(Label(
                              text: item['ingredient_name'],
                              style: context.appTextTheme.headlineSmall,
                            )),
                            DataCell(Label(
                              text: item['quantity'] == null
                                  ? "______"
                                  : (item['quantity'] ?? "______")
                                      .toString()
                                      .toDouble
                                      .toStringAsFixed(0),
                              style: context.appTextTheme.headlineSmall,
                            )),
                            DataCell(
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomButton(text: 'تعديل', onPressed: () {}),
                                  CustomButton(
                                      text: 'ازاله',
                                      color: context.theme.colorScheme.error,
                                      onPressed: () {
                                        context
                                            .read<RecipesBloc>()
                                            .deleteRecipe(item['id']);
                                      }),
                                ],
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
