import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/core/widgets/base_text.dart';
import 'package:flutter_woocommerce/core/widgets/no_connection.dart';
import 'package:flutter_woocommerce/core/widgets/toast.dart';
import 'package:flutter_woocommerce/features/cart/data/models/cart_item.dart';
import 'package:flutter_woocommerce/features/cart/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/features/cart/presentation/widgets/cart_list_tile.dart';
import 'package:flutter_woocommerce/features/checkout/presentation/screens/checkout_screen.dart';
import 'package:hive_flutter/adapters.dart';
import '../../../../core/widgets/base_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
          title: BaseText(
        localization.cart,
        style: Theme.of(context).textTheme.bodySmall!,
      )),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          switch (state.status) {
            case CartStatus.initial:
              return Center(
                child: CircularProgressIndicator(
                  color: kcPrimaryColor,
                ),
              );
            case CartStatus.success:
              return ValueListenableBuilder(
                valueListenable: Hive.box<CartItem>('cart').listenable(),
                builder: (context, value, _) {
                  var cartItems = value.values.map(
                    (e) {
                      if (state.cartItems.contains(e)) {
                        return e.copyWith(
                          productPrice: state.cartItems
                              .firstWhere((element) => element == e)
                              .productPrice,
                        );
                      }
                      return e;
                    },
                  );
                  var price = cartItems.isNotEmpty
                      ? cartItems
                          .map((e) => double.parse(e.productPrice) * e.quantity)
                          .reduce((a, b) => a + b)
                      : '0';
                  return Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: ListView.builder(
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              var item = cartItems.toList()[index];
                              return CartListTile(
                                  item: item, deleteItem: false);
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height:
                            screenHeightPercentage(context, percentage: .14),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: kcSecondaryColor),
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BaseText(
                                      localization.total_price,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!,
                                    ),
                                    BaseText(
                                      '$price\$',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!,
                                    )
                                  ],
                                ),
                                horizontalSpaceRegular,
                                Expanded(
                                  child: BaseButton(
                                    // icon: ,
                                    title: localization.checkout,
                                    callback: () {
                                      if (cartItems.isNotEmpty) {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                WebViewCheckoutScreen(
                                              cartItems: cartItems.toList(),
                                            ),
                                          ),
                                        );
                                      } else {
                                        showToast(
                                            localization.empty_cart_message);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            case CartStatus.failure:
              return NoConnectionWidget(reload: () {
                context.read<CartBloc>().add(LoadCartItems());
              });
          }
        },
      ),
    );
  }
}
