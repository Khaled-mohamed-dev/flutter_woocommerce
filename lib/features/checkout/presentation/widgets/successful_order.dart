import 'package:flutter/material.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/core/widgets/base_button.dart';
import 'package:flutter_woocommerce/core/widgets/base_text.dart';
import 'package:flutter_woocommerce/features/orders/data/repositories/orders_repository.dart';
import 'package:flutter_woocommerce/locator.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SuccessfulOrderPopup extends StatefulWidget {
  const SuccessfulOrderPopup({Key? key, required this.orderID})
      : super(key: key);
  final String orderID;
  @override
  State<SuccessfulOrderPopup> createState() => _SuccessfulOrderPopupState();
}

class _SuccessfulOrderPopupState extends State<SuccessfulOrderPopup> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    locator<OrdersRepository>().updateOrder(widget.orderID).then(
          (value) => setState(
            () => isLoading = false,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: kcPrimaryColor))
          : SafeArea(
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
                  BaseText(
                    localization.order_successful,
                    style: Theme.of(context).textTheme.bodyMedium!,
                  ),
                  BaseText(
                    "${localization.order_number} ${widget.orderID}",
                    style: Theme.of(context).textTheme.titleMedium!,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        verticalSpaceRegular,
                        BaseButton(
                          title: localization.back_to_store,
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
