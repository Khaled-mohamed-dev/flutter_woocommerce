import 'package:flutter/material.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/core/widgets/base_text.dart';

import 'responsive_icon.dart';

class NoConnectionWidget extends StatelessWidget {
  const NoConnectionWidget({
    super.key,
    required this.reload,
  });

  final Function reload;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/internet-offline.png',
            width: screenWidthPercentage(context, percentage: .5),
          ),
          verticalSpaceRegular,
          BaseText(
            'An error ocured\n Check your internet and try again',
            alignment: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium!,
          ),
          verticalSpaceRegular,
          IconButton(
            onPressed: () {
              reload();
            },
            icon: ResponsiveIcon(
              Icons.refresh,
              color: kcPrimaryColor,
            ),
          )
        ],
      ),
    );
  }
}
