import 'package:flutter/material.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/core/widgets/base_text.dart';
import 'package:flutter_woocommerce/core/widgets/responsive_icon.dart';
import 'package:flutter_woocommerce/features/favorites/data/models/favorite.dart';
import 'package:flutter_woocommerce/features/favorites/data/repositories/favorites_repository.dart';
import 'package:flutter_woocommerce/locator.dart';
import 'package:iconly/iconly.dart';

class FavoriteListTile extends StatelessWidget {
  const FavoriteListTile({
    super.key,
    required this.product,
  });

  final Favorite product;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var width = constraints.maxWidth;
        return Container(
          margin: const EdgeInsets.only(bottom: 12, right: 24, left: 24),
          decoration: BoxDecoration(
            color: kcCartItemBackgroundColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          12.0, 12.0, 0, 12.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          width: width * .2,
                          height: width * .2,
                          constraints: const BoxConstraints(
                              maxHeight: 200, maxWidth: 200),
                          color: kcSecondaryColor,
                          child: product.image.isNotEmpty
                              ? Image.network(product.image)
                              : const ResponsiveIcon(Icons.image),
                        ),
                      ),
                    ),
                    horizontalSpaceSmall,
                    Expanded(
                      child: BaseText(
                        product.productName,
                        style: Theme.of(context).textTheme.bodyMedium!,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                splashRadius: 1,
                onPressed: () {
                  locator<FavoritesRepository>().changeFavoriteStatus(product);
                },
                icon: const ResponsiveIcon(
                  IconlyLight.delete,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
