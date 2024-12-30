import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/enums/ingredient_enum.dart';
import 'package:pscorner/core/extensions/context_extension.dart';
import 'package:pscorner/core/extensions/string_extension.dart';
import 'package:pscorner/core/stateful/custom_drop_down_form_field.dart';
import 'package:pscorner/core/stateless/custom_app_bar.dart';
import 'package:pscorner/core/stateless/custom_button.dart';
import 'package:pscorner/core/stateless/custom_text_field.dart';
import 'package:pscorner/core/stateless/gaps.dart';
import 'package:pscorner/core/stateless/responsive_scaffold.dart';
import 'package:pscorner/core/theme/text_theme.dart';
import 'package:pscorner/features/recipes/presentation/blocs/recipes_cubit.dart';
import 'package:pscorner/features/recipes/presentation/blocs/recipes_state.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final ValueNotifier<String?> _selectedUnit =
      ValueNotifier<String?>(null); // To manage selected unit.
  final TextEditingController _quantityController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: const CustomAppBar(
        canPop: true,
      ),
      desktopBody: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppGaps.gap16Vertical,
                  CustomTextFormField(
                      width: context.width * 0.3,
                      hintText: 'اسم المنتج',
                      prefixIcon: Icons.inventory_2,
                      controller: _nameController),
                  AppGaps.gap16Vertical,
                  ValueListenableBuilder<String?>(
                    valueListenable: _selectedUnit,
                    builder: (context, value, _) {
                      return SizedBox(
                        width: context.width * 0.3,
                        child: CustomDropdownField<String>(
                          hintText: 'اختر الوحدة',
                          items: const ['كيلوجرام', 'جرام', 'لتر'],
                          value: value,
                          onChanged: (unit) {
                            _selectedUnit.value = unit;
                          },
                          hintStyle: AppTextTheme.bodyLarge,
                          itemStyle: AppTextTheme.bodyLarge
                              .copyWith(color: Colors.black54),
                        ),
                      );
                    },
                  ),
                  AppGaps.gap16Vertical,
                  CustomTextFormField(
                      width: context.width * 0.3,
                      hintText: 'الكميه',
                      prefixIcon: Icons.add_shopping_cart,
                      controller: _quantityController),
                  AppGaps.gap16Vertical,
                  AppGaps.gap16Vertical,
                  BlocConsumer<RecipesBloc, RecipesState>(
                    listener: (context, state) {
                      if (state.isSuccess) {
                        context.showSuccessMessage('تمت الاضافة بنجاح');

                        _quantityController.clear();

                        _nameController.clear();
                        _selectedUnit.value = null;
                      }
                      if (state.isError) {
                        context.showErrorMessage(state.errorMessage);
                      }
                    },
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return CustomButton(
                          text: 'إضافة',
                          width: context.width * 0.3,
                          onPressed: () {
                            if (_nameController.text.trim().isEmpty ||
                                _selectedUnit.value!.trim().isEmpty) {
                              context.showErrorMessage('يجب ملء جميع الحقول');

                              if (_quantityController.text.trim().isEmpty) {
                                context.showErrorMessage('يجب ملء الوزن');
                              }
                            } else {
                              context.read<RecipesBloc>().insertRecipe(
                                    quantity: _quantityController.text
                                        .trim()
                                        .toDouble,
                                    name: _nameController.text.trim(),
                                    ingredientName: _selectedUnit.value!.trim().ingredientEnum,
                                  );
                            }
                          });
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
