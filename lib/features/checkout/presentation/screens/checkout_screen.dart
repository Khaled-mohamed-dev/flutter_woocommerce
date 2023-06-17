import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/widgets/base_text.dart';
import 'package:flutter_woocommerce/core/widgets/no_connection.dart';
import 'package:flutter_woocommerce/features/cart/data/models/cart_item.dart';
import 'package:flutter_woocommerce/features/checkout/presentation/widgets/successful_order.dart';
import 'package:flutter_woocommerce/locator.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/consts.dart';
import '../../../../core/services/sharedpref_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../cart/presentation/bloc/bloc.dart';

class WebViewCheckoutScreen extends StatelessWidget {
  const WebViewCheckoutScreen({Key? key, required this.cartItems})
      : super(key: key);
  final List<CartItem> cartItems;

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
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

    CookieManager().clearCookies();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: BaseText(
          localization.checkout,
          style: Theme.of(context).textTheme.bodySmall!,
        )),
        body: WebView(
          initialUrl: '${siteUrl}checkout/${addToCartUrl()}',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (webViewController) async {
            controller = webViewController;
          },
          onWebResourceError: (e) {
            if (e.description.contains("ERR_INTERNET_DISCONNECTED")) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      leading: IconButton(
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ),
                    body: NoConnectionWidget(
                      reload: () async {
                        await controller!.reload();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              );
            }
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

            if (url.contains('shop')) {
              Navigator.of(context).pop();
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

            if (url.contains(siteUrl)) {
              if (!url.contains('checkout') && !url.contains('cart')) {
                return NavigationDecision.prevent;
              }
            }

            return NavigationDecision.navigate;
          },
        ),
      ),
    );
  }
}
