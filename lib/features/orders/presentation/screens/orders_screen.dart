import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/widgets/base_text.dart';
import 'package:flutter_woocommerce/core/widgets/no_connection.dart';
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
            title: BaseText(
          localization.orders,
          style: Theme.of(context).textTheme.bodySmall!,
        )),
        body: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (context, state) {
            switch (state.status) {
              case OrdersStatus.initial:
                return Center(
                    child: CircularProgressIndicator(color: kcPrimaryColor));
              case OrdersStatus.success:
                var orders = state.orders;
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: orders.isEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/$notFoundImage.png'),
                              verticalSpaceRegular,
                              BaseText(
                                localization.no_orders,
                                alignment: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium!,
                              ),
                            ],
                          )
                        : ListView.builder(
                            itemCount: orders.length,
                            itemBuilder: (context, index) {
                              var order = orders[index];
                              return OrderListTile(order: order);
                            },
                          ),
                  ),
                );
              case OrdersStatus.failure:
                return NoConnectionWidget(reload: () {
                  context.read<OrdersBloc>().add(LoadOrders());
                });
            }
          },
        ),
      ),
    );
  }
}
