import 'package:flutter/material.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/core/widgets/base_text.dart';
import 'package:flutter_woocommerce/core/widgets/responsive_icon.dart';

import '../colors.dart';

class BaseButton extends StatefulWidget {
  const BaseButton({
    Key? key,
    this.icon,
    this.iconColor,
    required this.title,
    required this.callback,
    this.isLoading = false,
    this.width,
  }) : super(key: key);

  final IconData? icon;
  final Color? iconColor;
  final String title;
  final Function callback;
  final bool isLoading;
  final double? width;
  @override
  State<BaseButton> createState() => _BaseButtonState();
}

class _BaseButtonState extends State<BaseButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        if (!widget.isLoading) {
          widget.callback();
        }
      },
      color:
          widget.iconColor ?? (widget.isLoading ? Colors.grey : kcPrimaryColor),
      elevation: 0,
      minWidth: widget.width ?? double.infinity,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.icon != null
              ? ResponsiveIcon(
                  widget.icon!,
                  color: kcButtonIconColor,
                )
              : const SizedBox.shrink(),
          widget.icon != null ? horizontalSpaceSmall : const SizedBox.shrink(),
          BaseText(
            widget.title.toUpperCase(),
            style: Theme.of(context).textTheme.labelLarge!,
          )
        ],
      ),
    );
  }
}
