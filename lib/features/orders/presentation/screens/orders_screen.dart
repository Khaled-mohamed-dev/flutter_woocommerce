import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/widgets/base_button.dart';
import 'package:flutter_woocommerce/features/orders/data/models/order.dart';
import 'package:flutter_woocommerce/features/orders/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/features/orders/presentation/screens/order_details.dart';
import 'package:flutter_woocommerce/features/reviews/presentation/widgets/create_review.dart';
import 'package:iconly/iconly.dart';

import '../../../../core/ui_helpers.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Orders'),
          bottom: TabBar(
            tabs: const <Widget>[
              Tab(icon: Text("In Delivery")),
              Tab(icon: Text("Completed")),
            ],
            indicatorWeight: 2,
            indicatorColor: kcPrimaryColor,
            labelColor: kcPrimaryColor,
            unselectedLabelColor: Colors.grey[700],
            padding: const EdgeInsets.symmetric(horizontal: 24),
          ),
        ),
        body: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (context, state) {
            List<Order> completedOrders = state.orders
                .where((element) => element.status == 'completed')
                .toList();
            return TabBarView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: state.orders.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/$notFoundImage.png'),
                            verticalSpaceRegular,
                            Text(
                              'You don\'t have any orders yet.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: state.orders.length,
                          itemBuilder: (context, index) {
                            var order = state.orders[index];
                            return OrderListTile(order: order);
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: completedOrders.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/$notFoundImage.png'),
                            verticalSpaceRegular,
                            Text(
                              'You don\'t have any orders yet.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: completedOrders.length,
                          itemBuilder: (context, index) {
                            var order = completedOrders[index];
                            return OrderListTile(order: order);
                          },
                        ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

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
