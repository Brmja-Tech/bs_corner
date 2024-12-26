import 'package:flutter/material.dart';
import 'package:pscorner/core/stateless/custom_text_field.dart';

class AddRecipeDialog extends StatefulWidget {
  const AddRecipeDialog({super.key});

  @override
  State<AddRecipeDialog> createState() => _AddRecipeDialogState();
}

class _AddRecipeDialogState extends State<AddRecipeDialog> {
  final TextEditingController _quantityController = TextEditingController();
  List<String> ingredients = ['ملح', 'فلفل', 'بصل', 'ثوم', 'بهارات'];
  List<String> selectedIngredients = [];
  String? ingredient;

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ingredients.isEmpty
          ? const Center(child: Text('لا يوجد مكونات'))
          : ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 600, maxWidth: 700),
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
                          return ListTile(
                            title: Text(selectedIngredients[index]),
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
                    SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          DropdownButton<String>(
                            enableFeedback: true,
                            isExpanded: true,
                            value: ingredient,
                            hint: const Text('اختر مكونًا'),
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            onChanged: (String? value) {
                              setState(() {
                                ingredient = value;
                              });
                            },
                            items: ingredients.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                         
                        ],
                      ),
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
                        }
                      },
                      child: const Text('إضافة'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
