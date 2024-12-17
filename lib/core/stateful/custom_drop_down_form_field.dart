import 'package:flutter/material.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final String hintText;
  final T? value;
  final List<T> items;
  final String? Function(T?)? validator;
  final void Function(T?) onChanged;
  final TextStyle? hintStyle;
  final TextStyle? itemStyle;

  const CustomDropdownField({
    super.key,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.value,
    this.validator,
    this.hintStyle,
    this.itemStyle,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      isExpanded: false,
      hint: Text(
        hintText,
        style: hintStyle ?? const TextStyle(color: Colors.black54),
      ),
      elevation: 0,
      alignment: Alignment.center,
      style: itemStyle ?? const TextStyle(color: Colors.black),
      value: value,
      validator: validator,
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          alignment: Alignment.center,
          value: item,
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Text(
              item.toString(),
              style: itemStyle ?? const TextStyle(color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
