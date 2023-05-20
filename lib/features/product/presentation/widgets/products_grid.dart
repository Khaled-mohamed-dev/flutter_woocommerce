import 'package:flutter/material.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
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
                        : const Center(child: Icon(Icons.image)),
                  ),
                  PositionedDirectional(
                    end: 10,
                    top: 10,
                    child: Transform.scale(
                      scale: .85,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                        child: FavoriteButton(product: product),
                      ),
                    ),
                  )
                ],
              ),
              verticalSpaceTiny,
              SizedBox(
                height: per / 3,
                child: Text(
                  product.name,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              verticalSpaceTiny,
              SizedBox(
                height: per / 3,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (Rect bounds) => LinearGradient(
                        stops: [ratePercentage, ratePercentage],
                        colors: [
                          kcIconColorSelected,
                          kcSecondaryColor,
                        ],
                      ).createShader(bounds),
                      child: Icon(
                        IconlyBold.star,
                        color: kcIconColorSelected,
                        size: 20,
                      ),
                    ),
                    horizontalSpaceTiny,
                    Text(
                      product.averageRating,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              verticalSpaceTiny,
              FittedBox(
                fit: BoxFit.fitHeight,
                child: SizedBox(
                  height: per / 3,
                  child: Text(
                    "\$${product.htmlPrice}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
