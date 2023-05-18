import 'package:flutter/material.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/widgets/base_button.dart';
import 'package:iconly/iconly.dart';

class ShippingAddressScreen extends StatelessWidget {
  const ShippingAddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final circularBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Shipping Address')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              // controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                // } else if (RegExp(
                //       r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
                //     ).hasMatch(value) ==
                //     false) {
                //   return "email is not valid";
                // }
                return null;
              },
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'address',
                hintStyle: Theme.of(context).textTheme.titleMedium,
                prefixIcon: Icon(
                  IconlyBold.location,
                  color: kcIconColorSelected,
                ),
                // prefixIconColor:kcPrimaryColor,
                focusColor: kcPrimaryColor,
                iconColor: kcPrimaryColor,
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
            ),
            BaseButton(
              title: 'Apply',
              callback: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}
