import 'package:flutter/material.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/core/widgets/base_text.dart';
import 'package:flutter_woocommerce/features/favorites/data/models/favorite.dart';
import 'package:flutter_woocommerce/features/favorites/presentation/widgets/favorites_list_tile.dart';
import 'package:flutter_woocommerce/features/product/data/repositories/products_repository.dart';
import 'package:flutter_woocommerce/features/product/presentation/screens/product_details.dart';
import 'package:flutter_woocommerce/locator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
          title: BaseText(
        localization.wish_slist,
        style: Theme.of(context).textTheme.bodySmall!,
      )),
      body: Stack(
        children: [
          ValueListenableBuilder(
            valueListenable: Hive.box<Favorite>('favorites').listenable(),
            builder: (context, box, _) {
              return ListView.builder(
                itemCount: box.values.length,
                itemBuilder: ((context, index) {
                  var product = box.values.toList()[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isLoading = true;
                      });
                      locator<ProductsRepository>()
                          .retrieveSinleProduct(product.productID)
                          .then(
                        (value) {
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetails(product: value),
                            ),
                          );
                        },
                      ).catchError((e) {
                        setState(() {
                          isLoading = false;
                        });
                      });
                    },
                    child: FavoriteListTile(product: product),
                  );
                }),
              );
            },
          ),
          if (isLoading)
            Container(
              width: screenWidth(context),
              height: screenHeight(context),
              color: Colors.black38,
              child: Center(
                child: CircularProgressIndicator(color: kcPrimaryColor),
              ),
            )
        ],
      ),
    );
  }
}
