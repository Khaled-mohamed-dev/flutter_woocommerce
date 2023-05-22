import 'package:flutter/material.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/core/widgets/base_button.dart';
import 'package:iconly/iconly.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: kcCartItemBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: kcPrimaryColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                IconlyBold.location,
                                color: kcButtonIconColor,
                              ),
                            ),
                          ),
                          horizontalSpaceSmall,
                          Expanded(
                            child: Text(
                              '',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          horizontalSpaceSmall,
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(IconlyBold.edit),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            BaseButton(title: 'Add Second Addess', callback: () {})
          ],
        ),
      ),
    );
  }
}
