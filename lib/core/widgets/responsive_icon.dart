import 'package:flutter/material.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';

class ResponsiveIcon extends StatelessWidget {
  const ResponsiveIcon(this.icon, {Key? key, this.color, this.size})
      : super(key: key);
  final IconData icon;
  final Color? color;
  final double? size;
  @override
  Widget build(BuildContext context) {
    var responsiveSize = (size ?? 24) * (screenWidth(context) / 4) / 100;
    return Icon(
      icon,
      size: responsiveSize,
      color: color,
    );
  }
}
