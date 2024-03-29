import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/core/widgets/base_text.dart';
import 'package:flutter_woocommerce/core/widgets/responsive_icon.dart';
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
                padding:
                    const EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 0, 12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: width * .3,
                    height: width * .3,
                    constraints:
                        const BoxConstraints(maxHeight: 200, maxWidth: 200),
                    color: kcSecondaryColor,
                    child: item.image.isNotEmpty
                        ? Image.network(item.image)
                        : const ResponsiveIcon(Icons.image),
                  ),
                ),
              ),
              horizontalSpaceSmall,
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0, 24.0, 12.0, 12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: BaseText(
                              item.productName,
                              style: Theme.of(context).textTheme.bodyMedium!,
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
                              icon: const ResponsiveIcon(IconlyLight.delete),
                            ),
                        ],
                      ),
                      // attributes if the product is variable
                      if (item.variationTitle != null)
                        Column(
                          children: [
                            verticalSpaceSmall,
                            BaseText(
                              item.variationTitle!,
                              style: Theme.of(context).textTheme.titleSmall!,
                            ),
                          ],
                        ),
                      verticalSpaceSmall,
                      !deleteItem
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BaseText(
                                  "${item.productPrice}\$",
                                  style: Theme.of(context).textTheme.bodyMedium!,
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
                                              .add(DecrementQuantity(
                                                  cartItem: item));
                                        },
                                        icon: const ResponsiveIcon(Icons.remove),
                                        splashRadius: 0.1,
                                      ),
                                      BaseText(
                                        item.quantity.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall!,
                                      ),
                                      IconButton(
                                        iconSize: 12,
                                        onPressed: () {
                                          BlocProvider.of<CartBloc>(context)
                                              .add(IncrementQuantity(
                                                  cartItem: item));
                                        },
                                        icon: const ResponsiveIcon(Icons.add),
                                        splashRadius: 0.1,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BaseText(
                                  "${item.productPrice}\$",
                                  style: Theme.of(context).textTheme.bodyMedium!,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: kcSecondaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: BaseText(
                                      item.quantity.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!,
                                    ),
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
