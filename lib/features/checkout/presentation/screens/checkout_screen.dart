import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/core/widgets/base_button.dart';
import 'package:flutter_woocommerce/core/widgets/toast.dart';
import 'package:flutter_woocommerce/features/cart/data/models/cart_item.dart';
import 'package:flutter_woocommerce/features/cart/presentation/widgets/cart_list_tile.dart';
import 'package:flutter_woocommerce/features/checkout/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/features/checkout/presentation/screens/payment_methods_screen.dart';
import 'package:flutter_woocommerce/features/checkout/presentation/screens/shipping_methods_screen.dart';
import 'package:flutter_woocommerce/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:flutter_woocommerce/features/settings/presentation/screens/shipping_address_screen.dart';

import 'package:flutter_woocommerce/locator.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key, required this.cartItems}) : super(key: key);
  final List<CartItem> cartItems;

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    var price = cartItems
        .map((e) => double.parse(e.productPrice) * e.quantity)
        .reduce((a, b) => a + b);
    var address = context.watch<SettingsBloc>().state.settingModel.address;
    return Scaffold(
      appBar: AppBar(title: Text(localization.checkout)),
      body: BlocProvider(
        create: (context) => locator<CheckoutBloc>()..add(LoadCheckout()),
        lazy: false,
        child: BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state.shippingAddress.isEmpty)
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                stops: const [0.015, 0.015],
                                colors: [kcPrimaryColor, kcSecondaryColor],
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Container(
                              margin:
                                  const EdgeInsetsDirectional.only(start: 4),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  localization.address_required_message,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                            ),
                          ),
                        Text(
                          localization.shipping_address,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        verticalSpaceSmall,
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<CheckoutBloc>(),
                                  child: const ShippingAddressScreen(),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: kcCartItemBackgroundColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      address.isEmpty
                                          ? localization.no_address
                                          : address,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
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
                    verticalSpaceSmall,
                    Divider(color: kcSecondaryColor),
                    verticalSpaceSmall,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localization.order_items,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        verticalSpaceSmall,
                        ...cartItems
                            .map((e) => CartListTile(item: e, deleteItem: true))
                      ],
                    ),
                    verticalSpaceSmall,
                    Divider(color: kcSecondaryColor),
                    verticalSpaceSmall,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state.selectedShippingMethod == null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                stops: const [0.015, 0.015],
                                colors: [kcPrimaryColor, kcSecondaryColor],
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Container(
                              margin:
                                  const EdgeInsetsDirectional.only(start: 4),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  localization.shipping_method_required_message,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                            ),
                          ),
                        Text(
                          localization.shipping_methods,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        verticalSpaceSmall,
                        Builder(
                          builder: (context) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: BlocProvider.of<CheckoutBloc>(
                                          context),
                                      child: const ShippingMethodsScreen(),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: kcCartItemBackgroundColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(
                                        Icons.local_shipping,
                                      ),
                                      horizontalSpaceSmall,
                                      Expanded(
                                        child: Text(
                                          state.selectedShippingMethod == null
                                              ? localization
                                                  .choose_shipping_method
                                              : state.selectedShippingMethod!
                                                  .title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ),
                                      horizontalSpaceSmall,
                                      const Icon(
                                          Icons.arrow_forward_ios_outlined),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                    verticalSpaceSmall,
                    Divider(color: kcSecondaryColor),
                    verticalSpaceSmall,
                    Container(
                      decoration: BoxDecoration(
                        color: kcCartItemBackgroundColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(localization.amount),
                                Text('$price\$')
                              ],
                            ),
                            verticalSpaceRegular,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(localization.shipping),
                                Text(state.selectedShippingMethod == null
                                    ? '_'
                                    : "${double.parse(state.selectedShippingMethod!.cost)} \$")
                              ],
                            ),
                            verticalSpaceSmall,
                            Divider(color: kcSecondaryColor),
                            verticalSpaceSmall,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(localization.total),
                                Text(
                                    '${price + double.parse(state.selectedShippingMethod?.cost ?? '0')}\$')
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    verticalSpaceRegular,
                    Builder(
                      builder: (context) {
                        return BaseButton(
                          title: localization.continue_payment,
                          callback: () {
                            if (state.shippingAddress.isEmpty ||
                                state.selectedShippingMethod == null) {
                              showToast(localization.missing_address_method);
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PaymentMethodsScreen(),
                                ),
                              );
                            }
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
