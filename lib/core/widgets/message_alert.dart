import 'package:flutter/material.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/core/widgets/base_text.dart';

class MessageAlert extends StatelessWidget {
  const MessageAlert({
    super.key,
    required this.message,
  });
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context) - 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.centerStart,
          end: AlignmentDirectional.centerEnd,
          stops: const [0.015, 0.015],
          colors: [kcPrimaryColor, kcSecondaryColor],
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        margin: const EdgeInsetsDirectional.only(start: 4),
        width: screenWidth(context) - 57,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: BaseText(
            message,
            style: Theme.of(context).textTheme.titleSmall!,
          ),
        ),
      ),
    );
  }
}
