import 'package:flutter/material.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/core/widgets/base_button.dart';
import 'package:flutter_woocommerce/features/checkout/presentation/screens/successful_order.dart';
import 'package:iconly/iconly.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Methods')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                children: [
                  RadioListTile(
                    value: true,
                    groupValue: true,
                    onChanged: (value) {},
                    tileColor: kcCartItemBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    title: Row(
                      children: [
                        Icon(
                          IconlyBold.wallet,
                          color: kcPrimaryColor,
                        ),
                        horizontalSpaceSmall,
                        const Text('Cash on Delivery'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            BaseButton(
              title: 'Confirm Payment',
              callback: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SuccessfulOrderPopup(),
                    ),
                    (route) => route.isFirst);
              },
            )
          ],
        ),
      ),
    );
  }
}
