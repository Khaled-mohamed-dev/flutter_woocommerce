import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/features/orders/data/models/order.dart';
import 'package:flutter_woocommerce/features/orders/presentation/bloc/bloc.dart';

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
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 12),
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
                                    // const Icon(
                                    //   Icons.local_shipping,
                                    // ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Order Number : ${order.id.toString()}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        Text(
                                          "order date: ${order.dateCreated?.formatDate()}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        )
                                      ],
                                    ),
                                    horizontalSpaceSmall,
                                    const Icon(
                                        Icons.arrow_forward_ios_outlined),
                                  ],
                                ),
                              ),
                            );
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
                      : ListView(
                          children:const [],
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
