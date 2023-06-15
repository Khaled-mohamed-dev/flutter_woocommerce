import 'package:flutter/material.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:shimmer/shimmer.dart';

class Skelton extends StatelessWidget {
  const Skelton({Key? key, this.height, this.width, this.radius})
      : super(key: key);
  final double? height, width, radius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: kcCartItemBackgroundColor,
      highlightColor: kcSecondaryColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 10),
          color: kcCartItemBackgroundColor,
        ),
      ),
    );
  }
}
