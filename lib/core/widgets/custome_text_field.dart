import 'package:flutter/material.dart';
import 'package:flutter_woocommerce/core/colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.keyboardType,
    required this.hint,
    this.icon,
    this.validator,
    this.readOnly = false,
    this.isPassword = false,
  });

  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String hint;
  final IconData? icon;
  final Function? validator;
  final bool readOnly;
  final bool isPassword;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final circularBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    );

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      validator: (value) {
        if (validator != null) {
          return validator!(value);
        }
        return null;
      },
      style: theme.textTheme.bodySmall,
      cursorColor: kcPrimaryColor,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.titleMedium,
        prefixIcon: icon == null
            ? null
            : Icon(
                icon,
                color: kcIconColorSelected,
              ),
        filled: true,
        fillColor: kcSecondaryColor,
        border: circularBorder.copyWith(
          borderSide: BorderSide(color: kcSecondaryColor),
        ),
        errorBorder: circularBorder.copyWith(
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedBorder: circularBorder.copyWith(
          borderSide: BorderSide(color: kcPrimaryColor),
        ),
        enabledBorder: circularBorder.copyWith(
          borderSide: BorderSide(color: kcSecondaryColor),
        ),
      ),
    );
  }
}
