import 'package:flutter/material.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/core/widgets/base_text.dart';
import 'package:flutter_woocommerce/features/orders/data/models/order.dart';
import 'package:flutter_woocommerce/features/reviews/presentation/widgets/create_review.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrdersDetails extends StatelessWidget {
  const OrdersDetails({Key? key, required this.order}) : super(key: key);
  final Order order;
  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    var statuses = {
      'processing': localization.processing,
      'pending': localization.pending,
      'completed': localization.completed,
      'on-hold': localization.on_hold,
      'cancelled': localization.cancelled,
      'refunded': localization.refunded,
      'failed': localization.failed,
      'trash': localization.trash
    };
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: BaseText(
        '${localization.order} #${order.id}',
        style: Theme.of(context).textTheme.bodySmall!,
      )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BaseText(
                  localization.order_status,
                  style: Theme.of(context).textTheme.bodyMedium!,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: kcSecondaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: BaseText(
                      statuses["${order.status}"] ?? '',
                      style: Theme.of(context).textTheme.titleSmall!,
                    ),
                  ),
                ),
              ],
            ),
            verticalSpaceRegular,
            Divider(color: kcSecondaryColor),
            verticalSpaceRegular,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseText(
                  localization.order_items,
                  style: Theme.of(context).textTheme.bodyMedium!,
                ),
                verticalSpaceRegular,
                ...order.lineItems.map((e) => LineItemTile(
                      item: e,
                      isCompleted: order.status == 'completed',
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}

class LineItemTile extends StatelessWidget {
  const LineItemTile({Key? key, required this.item, required this.isCompleted})
      : super(key: key);
  final LineItem item;
  final bool isCompleted;
  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: kcCartItemBackgroundColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BaseText(
                  item.name!,
                  style: Theme.of(context).textTheme.bodyMedium!,
                ),
                if (isCompleted)
                  GestureDetector(
                    onTap: () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40.0),
                            topRight: Radius.circular(40.0),
                          ),
                        ),
                        backgroundColor: kcButtonIconColor,
                        builder: (_) => ReviewBottomSheet(
                          productID: item.productId,
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: kcSecondaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: BaseText(
                          localization.leave_review,
                          style: Theme.of(context).textTheme.titleSmall!,
                        ),
                      ),
                    ),
                  )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BaseText(
                  "${localization.total}: ${item.total}",
                  style: Theme.of(context).textTheme.bodySmall!,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: kcSecondaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: BaseText(
                      item.quantity.toString(),
                      style: Theme.of(context).textTheme.headlineSmall!,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
