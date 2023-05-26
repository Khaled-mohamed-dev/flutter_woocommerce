import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/features/cart/data/models/cart_item.dart';
import 'package:flutter_woocommerce/features/cart/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/features/cart/presentation/widgets/confirm_delete_widget.dart';
import 'package:iconly/iconly.dart';

class CartListTile extends StatelessWidget {
  const CartListTile({
    super.key,
    required this.item,
    required this.deleteItem,
  });

  final CartItem item;
  final bool deleteItem;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var width = constraints.maxWidth;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: kcCartItemBackgroundColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 12.0, 0, 12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: width * .3,
                    height: width * .3,
                    color: kcSecondaryColor,
                    child: item.image.isNotEmpty
                        ? Image.network(item.image)
                        : const Icon(Icons.image),
                  ),
                ),
              ),
              horizontalSpaceSmall,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 24.0, 12.0, 12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.productName,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          if (!deleteItem)
                            IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40.0),
                                  ),
                                  backgroundColor: kcButtonIconColor,
                                  builder: (_) {
                                    return BlocProvider<CartBloc>.value(
                                      value: BlocProvider.of<CartBloc>(context),
                                      child:
                                          ConfirmDeleteBottomSheet(item: item),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(IconlyLight.delete),
                            ),
                        ],
                      ),
                      // attributes if the product is variable
                      if (item.variationTitle != null)
                        Column(
                          children: [
                            verticalSpaceSmall,
                            Text(
                              item.variationTitle!,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      verticalSpaceSmall,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${item.productPrice}\$",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: kcSecondaryColor,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  iconSize: 12,
                                  onPressed: () {
                                    BlocProvider.of<CartBloc>(context)
                                        .add(DecrementQuantity(cartItem: item));
                                  },
                                  icon: const Icon(Icons.remove),
                                  splashRadius: 0.1,
                                ),
                                Text(
                                  item.quantity.toString(),
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                IconButton(
                                  iconSize: 12,
                                  onPressed: () {
                                    BlocProvider.of<CartBloc>(context)
                                        .add(IncrementQuantity(cartItem: item));
                                  },
                                  icon: const Icon(Icons.add),
                                  splashRadius: 0.1,
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
