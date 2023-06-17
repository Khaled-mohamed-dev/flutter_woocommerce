import 'package:flutter/material.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';

class BaseText extends StatelessWidget {
  const BaseText(
    this.text, {
    Key? key,
    required this.style,
    this.alignment = TextAlign.start,
    this.maxLines,
  }) : super(key: key);

  final String text;
  final TextStyle style;
  final TextAlign alignment;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    var fontSize = (style.fontSize ?? 14) * (screenWidth(context) / 3.5) / 100;
    return Text(
      text,
      style: style.copyWith(fontSize: fontSize),
      textAlign: alignment,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
    );
  }
}
