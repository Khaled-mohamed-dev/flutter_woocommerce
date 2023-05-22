import 'package:flutter/material.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/features/orders/presentation/screens/order_details.dart';

import '../../data/models/order.dart';

class OrderListTile extends StatelessWidget {
  const OrderListTile({
    super.key,
    required this.order,
  });
  final Order order;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OrdersDetails(order: order),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: kcCartItemBackgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order Number : ${order.id.toString()}",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    verticalSpaceTiny,
                    Text(
                      "order date: ${order.dateCreated?.formatDate()}",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    verticalSpaceTiny,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "total: ${order.total}",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        horizontalSpaceSmall,
                        Container(
                          decoration: BoxDecoration(
                            color: kcSecondaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text(
                              "${order.status}",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              horizontalSpaceSmall,
              const Icon(Icons.arrow_forward_ios_outlined),
            ],
          ),
        ),
      ),
    );
  }
}

extension DateTimeParse on String {
  DateTime dateTimeParse() {
    List<String> date = split('-');
    var year = date[0];
    var month = int.parse(date[1]) < 10 ? '0${date[1]}' : date[1];
    var day = int.parse(date[2]) < 10 ? '0${date[1]}' : date[1];
    return DateTime.parse('$year-$month-$day');
  }
}

extension FormatDate on DateTime {
  String formatDate() {
    return '$year-$month-$day';
  }
}
