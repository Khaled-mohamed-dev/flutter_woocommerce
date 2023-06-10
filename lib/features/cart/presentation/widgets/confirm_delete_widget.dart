import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/core/widgets/base_button.dart';
import 'package:flutter_woocommerce/features/cart/data/models/cart_item.dart';
import 'package:flutter_woocommerce/features/cart/presentation/widgets/cart_list_tile.dart';

import '../bloc/bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfirmDeleteBottomSheet extends StatelessWidget {
  const ConfirmDeleteBottomSheet({Key? key, required this.item})
      : super(key: key);
  final CartItem item;
  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            localization.remove_cart_item_confirmation,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Divider(color: kcSecondaryColor),
          verticalSpaceSmall,
          CartListTile(item: item, deleteItem: true),
          Divider(color: kcSecondaryColor),
          verticalSpaceSmall,
          Row(
            children: [
              Expanded(
                child: BaseButton(
                  callback: () {
                    Navigator.of(context).pop();
                  },
                  title: localization.cancel,
                  iconColor: Colors.grey,
                ),
              ),
              horizontalSpaceSmall,
              Expanded(
                child: BaseButton(
                  callback: () {
                    BlocProvider.of<CartBloc>(context).add(
                      RemoveItemFromCart(cartItem: item),
                    );
                    Navigator.of(context).pop();
                  },
                  title: localization.confirm_delete,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
