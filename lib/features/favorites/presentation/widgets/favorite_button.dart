import 'package:flutter/material.dart';
import 'package:flutter_woocommerce/core/widgets/responsive_icon.dart';
import 'package:flutter_woocommerce/features/favorites/data/models/favorite.dart';
import 'package:flutter_woocommerce/features/favorites/data/repositories/favorites_repository.dart';
import 'package:flutter_woocommerce/features/product/data/models/product.dart';
import 'package:flutter_woocommerce/locator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconly/iconly.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Favorite>('favorites').listenable(),
      builder: (context, values, _) {
        var isFavorited =
            locator<FavoritesRepository>().isFavorited(product.id);
        return GestureDetector(
          onTap: () {
            locator<FavoritesRepository>().changeFavoriteStatus(
              Favorite(
                productID: product.id,
                productName: product.name,
                image: product.images.isEmpty ? '' : product.images[0],
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            // visualDensity: VisualDensity.compact,
            child: ResponsiveIcon(
              isFavorited ? IconlyBold.heart : IconlyLight.heart,
              color: isFavorited ? Colors.red : null,
            ),
          ),
        );
      },
    );
  }
}
