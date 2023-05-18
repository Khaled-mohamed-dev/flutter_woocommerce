import 'package:flutter/material.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/core/widgets/base_button.dart';
import 'package:iconly/iconly.dart';

class SuccessfulOrderPopup extends StatelessWidget {
  const SuccessfulOrderPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kcPrimaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Icon(
                  IconlyBold.buy,
                  color: kcButtonIconColor,
                  size: 40,
                ),
              ),
            ),
            verticalSpaceRegular,
            Text('Order Successful!',
                style: Theme.of(context).textTheme.bodyMedium),
            Text('You have successfully made order!',
                style: Theme.of(context).textTheme.titleMedium),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  BaseButton(title: 'View Order', callback: () {}),
                  verticalSpaceRegular,
                  BaseButton(
                    title: 'Leave',
                    callback: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
