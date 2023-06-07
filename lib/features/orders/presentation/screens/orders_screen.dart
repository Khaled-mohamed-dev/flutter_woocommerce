import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/features/orders/data/models/order.dart';
import 'package:flutter_woocommerce/features/orders/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/features/orders/presentation/widgets/order_list_tile.dart';

import '../../../../core/ui_helpers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Orders'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(icon: Text(localization.processing)),
              Tab(icon: Text(localization.completed)),
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
            switch (state.status) {
              case OrdersStatus.initial:
                return Center(
                    child: CircularProgressIndicator(color: kcPrimaryColor));
              case OrdersStatus.success:
                List<Order> completedOrders = state.orders
                    .where((element) => element.status == 'completed')
                    .toList();
                List<Order> processingOrders = state.orders
                    .where((element) => element.status != 'completed')
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
                                  localization.no_orders,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            )
                          : ListView.builder(
                              itemCount: processingOrders.length,
                              itemBuilder: (context, index) {
                                var order = processingOrders[index];
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
                                  localization.no_orders,
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
              case OrdersStatus.failure:
                return const Center(
                  child: Text('some thing went wrong'),
                );
            }
          },
        ),
      ),
    );
  }
}
