import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/services/sharedpref_service.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/features/settings/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/features/settings/presentation/screens/shipping_address_screen.dart';
import 'package:flutter_woocommerce/locator.dart';
import 'package:iconly/iconly.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = locator<SharedPrefService>().user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: user == null
            ? const Center(
                child: Text('You need to sign in to show these details'),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
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
                                  context
                                      .watch<SettingsBloc>()
                                      .state
                                      .settingModel
                                      .address,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              horizontalSpaceSmall,
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ShippingAddressScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(IconlyBold.edit),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
