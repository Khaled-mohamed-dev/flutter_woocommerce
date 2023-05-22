import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/widgets/base_button.dart';
import 'package:flutter_woocommerce/core/widgets/toast.dart';
import 'package:flutter_woocommerce/features/checkout/presentation/bloc/bloc.dart';
import 'package:iconly/iconly.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({Key? key}) : super(key: key);

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  TextEditingController controller = TextEditingController();

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
              controller: controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              style: Theme.of(context).textTheme.titleMedium,
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
                if (controller.text.isNotEmpty) {
                  context
                      .read<CheckoutBloc>()
                      .add(ChangeAddress(controller.text));
                  Navigator.of(context).pop();
                } else {
                  showToast('Make sure to enter a valid address');
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
