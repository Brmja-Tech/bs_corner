import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/extensions/context_extension.dart';
import 'package:pscorner/core/extensions/string_extension.dart';
import 'package:pscorner/core/helper/functions.dart';
import 'package:pscorner/core/stateful/custom_drop_down_form_field.dart';
import 'package:pscorner/core/stateless/custom_app_bar.dart';
import 'package:pscorner/core/stateless/custom_button.dart';
import 'package:pscorner/core/stateless/custom_text_field.dart';
import 'package:pscorner/core/stateless/gaps.dart';
import 'package:pscorner/core/stateless/label.dart';
import 'package:pscorner/core/stateless/responsive_scaffold.dart';
import 'package:pscorner/core/theme/text_theme.dart';
import 'package:pscorner/features/employees/presentation/widgets/add_recipe_dialog.dart';
import 'package:pscorner/features/restaurants/presentation/blocs/restaurants_cubit.dart';
import 'package:pscorner/features/restaurants/presentation/blocs/restaurants_state.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  File? _selectedImage;
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String> restaurantTypes = [
    "مأكولات",
    "مشروبات",
  ];

  String type = '';

  String get selectedType => type == 'مأكولات' ? 'dish' : 'drink';

// Method to pick an image
  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedImage = File(result.files.single.path!);
        });
      }
    } catch (e) {
      // Handle errors
      debugPrint("Error picking image: $e");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _focusNode.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: const CustomAppBar(
        canPop: true,
      ),
      desktopBody: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Form(
              key: _formKey,
              child: Row(
                children: [
                  SizedBox(
                    width: context.width * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                            padding:
                                EdgeInsets.only(top: context.height * 0.15)),
                        const Label(text: 'اضافه مأكولات او مشروبات'),
                        AppGaps.gap16Vertical,
                        CustomTextFormField(
                          hintText: 'اسم المنتج',
                          prefixIcon: Icons.restaurant_rounded,
                          controller: _nameController,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء ادخال اسم المنتج';
                            }
                            return '';
                          },
                        ),
                        AppGaps.gap16Vertical,
                        CustomTextFormField(
                          hintText: 'سعر المنتج',
                          prefixIcon: Icons.monetization_on_outlined,
                          controller: _priceController,
                          formatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(
                                  r'^[\d\u0660-\u0669]+\.?[\d\u0660-\u0669]{0,2}'),
                            ),
                          ],
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء ادخال سعر المنتج';
                            }
                            return '';
                          },
                        ),
                        AppGaps.gap16Vertical,
                        CustomDropdownField<String>(
                          hintText: 'اختر الصنف',
                          items: restaurantTypes,
                          validator: (value) {
                            if (value == null) {
                              return 'الرجاء ادخال الصنف';
                            } else {
                              return null;
                            }
                          },
                          hintStyle: AppTextTheme.bodyLarge,
                          itemStyle: AppTextTheme.bodyLarge
                              .copyWith(color: Colors.black54),
                          value: type.isEmpty ? null : type,
                          onChanged: (String? value) {
                            setState(() {
                              type = value ?? '';
                            });
                          },
                        ),
                        AppGaps.gap16Vertical,
                        CustomButton(
                          width: double.infinity,
                          text: 'اضافة الوصفة',
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const AddRecipeDialog();
                                });
                          },
                        ),
                        const SizedBox(height: 18),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40.0),
                              child: ElevatedButton.icon(
                                onPressed: _pickImage,
                                style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    backgroundColor:
                                        const Color.fromRGBO(44, 102, 153, 1),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 150,
                                      vertical: 15,
                                    )),
                                icon: const Icon(Icons.image),
                                label: const Text('صوره'),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                        AppGaps.gap28Vertical,
                        BlocListener<RestaurantsBloc, RestaurantsState>(
                          listener: (context, state) {
                            if (state.isAdded) {
                              setState(() {
                                _nameController.clear();
                                _priceController.clear();
                                _nameController.clear();
                                _selectedImage = null;
                                type = '';
                                context.read<RestaurantsBloc>().clearRecipes();
                              });
                              context.showSuccessMessage('تم الاضافه بنجاح');
                            }
                          },
                          child: BlocBuilder<RestaurantsBloc, RestaurantsState>(
                            builder: (context, state) {
                              if (state.isLoading) {
                                return const CircularProgressIndicator();
                              }
                              return CustomButton(
                                text: 'إضافه',
                                width: context.width * 0.2,
                                onPressed: () {
                                  logger(_selectedImage?.path);
                                  logger(_nameController.text);
                                  logger(_priceController.text);
                                  logger(selectedType);
                                  if (_selectedImage == null) {
                                    context
                                        .showErrorMessage('ادخل صورة المنتج');
                                    return;
                                  }

                                  context.read<RestaurantsBloc>().insertItem(
                                        name: _nameController.text.trim(),
                                        imagePath: _selectedImage!.path,
                                        price: _priceController.text
                                            .trim()
                                            .numerate,
                                        type: selectedType,
                                    recipes:state.recipes,
                                      );
                                },
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 20),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  _selectedImage != null
                      ? Expanded(
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                  IconButton(
                                      icon: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _selectedImage = null;
                                        });
                                      })
                                ],
                              ),
                            ),
                          ),
                        )
                      : const Expanded(
                          child: Center(
                            child: Text(
                              'لم يتم اختيار صورة',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
