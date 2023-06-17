import 'package:flutter/material.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';

import 'responsive_icon.dart';

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
      obscureText: isPassword,
      validator: (value) {
        if (validator != null) {
          return validator!(value);
        }
        return null;
      },
      style: theme.textTheme.bodySmall!.copyWith(
          fontSize: theme.textTheme.bodySmall!.fontSize! *
              (screenWidth(context) / 3.5) /
              100),
      cursorColor: kcPrimaryColor,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontSize: theme.textTheme.titleMedium!.fontSize! *
                (screenWidth(context) / 3.5) /
                100),
        prefixIcon: icon == null
            ? null
            : ResponsiveIcon(
                icon!,
                color: kcPrimaryColor,
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
