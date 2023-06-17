import 'package:flutter/material.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/core/widgets/base_text.dart';
import 'package:flutter_woocommerce/core/widgets/responsive_icon.dart';
import 'package:flutter_woocommerce/features/favorites/presentation/widgets/favorite_button.dart';
import 'package:flutter_woocommerce/features/product/data/models/product.dart';
import 'package:flutter_woocommerce/features/product/presentation/screens/product_details.dart';
import 'package:iconly/iconly.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    super.key,
    required this.products,
  });
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.width > 700;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isTablet ? 3 : 2,
          childAspectRatio: 1 / 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          var product = products[index];
          return ProductCard(product: product);
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    double ratePercentage = double.parse(product.averageRating) / 5;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetails(product: product),
          ),
        );
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          var per = (constraints.maxHeight - constraints.maxWidth) - 15;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: kcSecondaryColor,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: kcSecondaryColor)),
                    height: constraints.maxWidth,
                    width: constraints.maxWidth,
                    child: product.images.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.network(
                              product.images.first,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Center(child: ResponsiveIcon(Icons.image)),
                  ),
                  PositionedDirectional(
                    end: 10,
                    top: 10,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: Transform.scale(
                        scale: .9,
                        child: Center(
                          child: IconTheme(
                            data: const IconThemeData(color: Colors.white),
                            child: FavoriteButton(product: product),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (product.onSale && product.type != ProductType.grouped)
                    PositionedDirectional(
                      start: 10,
                      top: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: BaseText(
                            "${(int.parse(product.salePrice) / int.parse(product.regularPrice) * 100).toInt()}%",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              ),
              verticalSpaceTiny,
              SizedBox(
                height: per * .4,
                width: constraints.maxWidth,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  clipBehavior: Clip.hardEdge,
                  alignment: AlignmentDirectional.centerStart,
                  child: BaseText(
                    product.name,
                    style: Theme.of(context).textTheme.bodySmall!,
                    maxLines: 1,
                  ),
                ),
              ),
              verticalSpaceTiny,
              SizedBox(
                height: per * .3,
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (Rect bounds) => LinearGradient(
                          stops: [ratePercentage, ratePercentage],
                          colors: [
                            kcPrimaryColor,
                            kcSecondaryColor,
                          ],
                        ).createShader(bounds),
                        child: ResponsiveIcon(
                          IconlyBold.star,
                          color: kcPrimaryColor,
                          size: 20,
                        ),
                      ),
                      horizontalSpaceTiny,
                      FittedBox(
                        fit: BoxFit.fitHeight,
                        child: BaseText(
                          product.averageRating,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(height: 1.5),
                          alignment: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              verticalSpaceTiny,
              FittedBox(
                fit: BoxFit.fitHeight,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  height: per * .3,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.onSale && product.type != ProductType.grouped)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(end: 4.0),
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: BaseText(
                              '${product.regularPrice}\$',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    height: 1.5,
                                  ),
                            ),
                          ),
                        ),
                      FittedBox(
                        fit: BoxFit.fitHeight,
                        child: BaseText(
                          product.onSale && product.type != ProductType.grouped
                              ? product.price
                              : product.htmlPrice,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
