import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/extensions/string_extension.dart';
import 'package:pscorner/core/helper/functions.dart';
import 'package:pscorner/core/stateless/custom_text_field.dart';
import 'package:pscorner/features/recipes/data/models/recipe_model.dart';
import 'package:pscorner/features/recipes/presentation/blocs/recipes_cubit.dart';
import 'package:pscorner/features/recipes/presentation/blocs/recipes_state.dart';
import 'package:pscorner/features/restaurants/data/datasources/restaurants_data_source.dart';
import 'package:pscorner/features/restaurants/presentation/blocs/restaurants_cubit.dart';

class AddRecipeDialog extends StatefulWidget {
  const AddRecipeDialog({super.key});

  @override
  State<AddRecipeDialog> createState() => _AddRecipeDialogState();
}

class _AddRecipeDialogState extends State<AddRecipeDialog> {
  final TextEditingController _quantityController = TextEditingController();

  List<RecipeModel> selectedIngredients = [];
  RecipeModel? ingredient;

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipesBloc, RecipesState>(
      builder: (context, state) {
        return Dialog(
          child: state.recipes.isEmpty
              ? const Center(child: Text('لا يوجد مكونات'))
              : ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxHeight: 600, maxWidth: 700),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.withOpacity(.3),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListView.builder(
                            itemCount: selectedIngredients.length,
                            itemBuilder: (context, index) {
                              logger(selectedIngredients);
                              return ListTile(
                                title: Text(selectedIngredients[index].name),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      selectedIngredients.removeAt(index);
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          enableFeedback: true,
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(20),
                          focusColor: Colors.white,
                          value: ingredient?.name,
                          hint: const Text('اختر مكونًا'),
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          onChanged: (String? value) {
                            setState(() {
                              ingredient = state.recipes
                                  .where((e) => e.name == value)
                                  .first;
                            });
                          },
                          items: state.recipes.map((value) {
                            return DropdownMenuItem<String>(
                              value:
                                  value.name, // Use the unique identifier here
                              child: Text(value.name),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          hintText: 'اختر الكمية',
                          prefixIcon: Icons.kebab_dining,
                          controller: _quantityController,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (ingredient != null &&
                                !selectedIngredients.contains(ingredient)) {
                              setState(() {
                                selectedIngredients.add(ingredient!);
                              });
                              context.read<RestaurantsBloc>().setRecipes(Recipe(
                                  recipeId: ingredient!.id.numerate.toInt(),
                                  name: ingredient!.name,
                                  quantity: _quantityController.text
                                      .trim()
                                      .toDouble));
                              _quantityController.clear();
                            }
                          },
                          child: const Text('إضافة'),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
