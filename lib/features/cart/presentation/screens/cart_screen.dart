import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/services/sharedpref_service.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/core/widgets/toast.dart';
import 'package:flutter_woocommerce/features/cart/data/models/cart_item.dart';
import 'package:flutter_woocommerce/features/cart/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/features/cart/presentation/widgets/cart_list_tile.dart';
import 'package:flutter_woocommerce/features/checkout/presentation/screens/checkout_screen.dart';
import 'package:flutter_woocommerce/features/checkout/presentation/screens/successful_order.dart';
import 'package:flutter_woocommerce/locator.dart';
import 'package:flutter_woocommerce/main.dart';
import 'package:hive_flutter/adapters.dart';
import '../../../../core/consts.dart';
import '../../../../core/widgets/base_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(localization.cart)),
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
                                    Text(
                                      localization.total_price,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    Text(
                                      '$price\$',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
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
                                        // from config.dart you can change wether to have a webview checkout or a native one
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                webviewCheckout
                                                    ? WebViewCheckoutScreen(
                                                        cartItems:
                                                            cartItems.toList(),
                                                      )
                                                    : CheckoutScreen(
                                                        cartItems:
                                                            cartItems.toList(),
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
              return const Center(child: Text('something went wrong'));
          }
        },
      ),
    );
  }
}

class WebViewCheckoutScreen extends StatelessWidget {
  const WebViewCheckoutScreen({Key? key, required this.cartItems})
      : super(key: key);
  final List<CartItem> cartItems;

  @override
  Widget build(BuildContext context) {
    bool isSignedin = locator<SharedPrefService>().user != null;
    WebViewController? controller;

    String addToCartUrl() {
      String items = '';
      for (var element in cartItems) {
        if (element.variationID != null) {
          items += "${element.variationID.toString()}," * element.quantity;
        } else {
          items += "${element.productID.toString()}," * element.quantity;
        }
      }
      return "?add-to-cart=$items";
    }

    logger.wtf(addToCartUrl());
    CookieManager().clearCookies();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: WebView(
          initialUrl: '${siteUrl}checkout/${addToCartUrl()}',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (webViewController) async {
            controller = webViewController;
          },
          onPageFinished: (url) async {
            await controller!.runJavascriptReturningResult(
              '''
                document.querySelector('.storefront-breadcrumb').style.display = 'none';
                document.querySelector('.storefront-handheld-footer-bar').hidden = true; 
                document.querySelector('.woocommerce-notices-wrapper').hidden = true; 
                document.querySelector('header').style.display = 'none';
                document.querySelector('footer').style.display = 'none';

              ''',
            );
            if (isSignedin) {
              var user = locator<SharedPrefService>().user!;
              controller!.runJavascript(
                '''
                  document.querySelector('.woocommerce-form-login-toggle').hidden = true;
                  document.querySelector('.woocommerce-account-fields').hidden = true;
                  document.getElementById('billing_email').value = "${user.email ?? ''}" ;
                  document.getElementById('billing_phone').value = "${user.billing?.phone ?? ''}";
                  document.getElementById('billing_first_name').value = "${user.billing?.firstName ?? ''}";
                  document.getElementById('billing_last_name').value = "${user.billing?.lastName ?? ''}";
                ''',
              );
            }
          },
          navigationDelegate: (navigation) {
            var url = navigation.url;
            print(url);

            if (url.contains('shop')) {
              Navigator.of(context).pop();
            }

            if (url.contains(siteUrl)) {
              if (!url.contains('checkout') && !url.contains('cart')) {
                print('prevent');
                return NavigationDecision.prevent;
              }
            }

            if (url.contains('order-received') && isSignedin) {
              context.read<CartBloc>().add(ClearCartItems());
              if (isSignedin) {
                // now here i will update the order by the id and change the customer id to the current user id if he is signed in;
                var orderID =
                    url.substring(url.indexOf('order-received')).split('/')[1];
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SuccessfulOrderPopup(orderID: orderID),
                    ),
                    (route) => route.isFirst);
              }
            }
            print('navigate');
            return NavigationDecision.navigate;
          },
        ),
      ),
    );
  }
}
