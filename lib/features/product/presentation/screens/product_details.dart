import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/core/widgets/base_button.dart';
import 'package:flutter_woocommerce/core/widgets/base_text.dart';
import 'package:flutter_woocommerce/core/widgets/message_alert.dart';
import 'package:flutter_woocommerce/core/widgets/no_connection.dart';
import 'package:flutter_woocommerce/core/widgets/responsive_icon.dart';
import 'package:flutter_woocommerce/features/favorites/presentation/widgets/favorite_button.dart';
import 'package:flutter_woocommerce/features/product/data/models/product_variation.dart';
import 'package:flutter_woocommerce/features/product/data/repositories/products_repository.dart';
import 'package:flutter_woocommerce/features/product/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/features/product/presentation/widgets/attributes_section.dart';
import 'package:flutter_woocommerce/features/product/presentation/widgets/image_section.dart';
import 'package:flutter_woocommerce/features/reviews/presentation/screens/reviews_screen.dart';
import 'package:iconly/iconly.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../locator.dart';
import '../../data/models/product.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final ScrollController _controller = ScrollController();

class ProductDetails extends StatelessWidget {
  const ProductDetails({Key? key, required this.product}) : super(key: key);
  final Product product;
  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    var stockStatuses = {
      "instock": localization.instock,
      "outofstock": localization.outofstock
    };

    double ratePercentage = double.parse(product.averageRating) / 5;
    var images = product.images;
    return Scaffold(
      body: BlocProvider(
        create: (context) => locator<ProductsBloc>()..add(InitPage(product)),
        child: BlocBuilder<ProductsBloc, ProductsState>(
          builder: (context, state) {
            switch (state.status) {
              case ProductsStatus.initial:
                return Center(
                  child: CircularProgressIndicator(color: kcPrimaryColor),
                );
              case ProductsStatus.success:
                return SafeArea(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: screenHeightPercentage(context,
                                percentage: .85),
                            child: ListView(
                              controller: _controller,
                              children: [
                                Stack(
                                  children: [
                                    ImageSection(images: images),
                                    if (product.onSale &&
                                        product.type != ProductType.grouped)
                                      PositionedDirectional(
                                        end: 30,
                                        top: 30,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: BaseText(
                                              "${(int.parse(product.salePrice) / int.parse(product.regularPrice) * 100).toInt()}%",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: screenWidthPercentage(
                                                        context,
                                                        percentage: .85) -
                                                    48,
                                                child: BaseText(
                                                  product.name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineMedium!,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: kcSecondaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6),
                                                      child: BaseText(
                                                        "${product.totalSales} ${localization.sold}",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall!,
                                                      ),
                                                    ),
                                                  ),
                                                  horizontalSpaceSmall,
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ReviewsScreen(
                                                                  product:
                                                                      product),
                                                        ),
                                                      );
                                                    },
                                                    child: Row(
                                                      children: [
                                                        ShaderMask(
                                                          blendMode:
                                                              BlendMode.srcIn,
                                                          shaderCallback: (Rect
                                                                  bounds) =>
                                                              LinearGradient(
                                                            stops: [
                                                              ratePercentage,
                                                              ratePercentage
                                                            ],
                                                            colors: [
                                                              kcPrimaryColor,
                                                              kcSecondaryColor,
                                                            ],
                                                          ).createShader(
                                                                  bounds),
                                                          child:
                                                              const ResponsiveIcon(
                                                                  IconlyBold
                                                                      .star),
                                                        ),
                                                        horizontalSpaceTiny,
                                                        BaseText(
                                                          "${product.averageRating} (${product.ratingCount})",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium!,
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              verticalSpaceTiny,
                                              BaseText(
                                                stockStatuses[
                                                        product.stockStatus] ??
                                                    product.stockStatus,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!,
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              FavoriteButton(product: product),
                                              IconButton(
                                                onPressed: () {
                                                  Share.share(
                                                      product.permalink);
                                                },
                                                icon: const ResponsiveIcon(
                                                    Icons.share),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      if (product.type == ProductType.variable)
                                        AttributesSection(
                                          attributes: state.attributes!,
                                          combinations: state.combinations!,
                                          controller: _controller,
                                        ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Divider(color: kcSecondaryColor),
                                          BaseText(
                                            localization.description,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall!,
                                          ),
                                          verticalSpaceTiny,
                                          Html(
                                            data: product.description,
                                            style: {
                                              'div': Style(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge!
                                                    .color,
                                                fontSize: FontSize(
                                                  Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .fontSize! *
                                                      (screenWidth(context) /
                                                          3.5) /
                                                      100,
                                                ),
                                                padding:
                                                    const EdgeInsets.all(0),
                                                margin: const EdgeInsets.all(0),
                                              ),
                                              'p': Style(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge!
                                                    .color,
                                                padding:
                                                    const EdgeInsets.all(0),
                                                margin: const EdgeInsets.all(0),
                                                fontSize: FontSize(
                                                  Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .fontSize! /
                                                      (screenWidth(context) /
                                                          3.5) /
                                                      100,
                                                ),
                                              )
                                            },
                                          ),
                                          Divider(color: kcSecondaryColor),
                                        ],
                                      ),
                                      verticalSpaceSmall,
                                      if (product.type == ProductType.grouped)
                                        ProductsCollection(
                                            products: state.groupedProducts!),
                                      verticalSpaceRegular,
                                      Row(
                                        children: [
                                          BaseText(
                                            localization.quantity,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall!,
                                          ),
                                          horizontalSpaceRegular,
                                          Container(
                                            decoration: BoxDecoration(
                                              color: kcSecondaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    BlocProvider.of<
                                                                ProductsBloc>(
                                                            context)
                                                        .add(
                                                            DecrementQuantity());
                                                  },
                                                  icon: const ResponsiveIcon(
                                                      Icons.remove),
                                                  splashRadius: 0.1,
                                                ),
                                                BaseText(
                                                  state.qunatity.toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineSmall!,
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    BlocProvider.of<
                                                                ProductsBloc>(
                                                            context)
                                                        .add(
                                                            IncrementQuantity());
                                                  },
                                                  icon: const ResponsiveIcon(
                                                      Icons.add),
                                                  splashRadius: 0.1,
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: kcSecondaryColor),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        BaseText(
                                          localization.total_price,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!,
                                        ),
                                        Row(
                                          children: [
                                            if (product.onSale &&
                                                product.type !=
                                                    ProductType.grouped)
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .only(end: 4.0),
                                                child: BaseText(
                                                  '${product.regularPrice}\$',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                      ),
                                                ),
                                              ),
                                            BaseText(
                                              '${state.price}\$',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall!,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    horizontalSpaceRegular,
                                    Expanded(
                                      child: BaseButton(
                                        icon:
                                            product.type == ProductType.external
                                                ? Icons.link_rounded
                                                : IconlyBold.bag,
                                        title:
                                            product.type == ProductType.external
                                                ? product.buttonText
                                                : localization.add_to_cart,
                                        callback: () {
                                          BlocProvider.of<ProductsBloc>(context)
                                              .add(HandleButtonClick(product));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      PositionedDirectional(
                        start: 15,
                        top: 15,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const ResponsiveIcon(Icons.arrow_back),
                        ),
                      ),
                    ],
                  ),
                );
              case ProductsStatus.failure:
                return NoConnectionWidget(reload: () {
                  context.read<ProductsBloc>().add(InitPage(product));
                });
            }
          },
        ),
      ),
    );
  }
}

class ProductsCollection extends StatelessWidget {
  const ProductsCollection({
    super.key,
    required this.products,
  });

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    return BlocBuilder<ProductsBloc, ProductsState>(
      builder: (context, state) {
        // ------------------------------------------ // ------------------------------------------ //

        // This Block of code is only used if the grouped product contains any variable product
        // It make sure that the user chooses a variation for each available variable product
        // This imitates the functionality of a Plugin name "WPC Grouped Product for WooCommerce"

        Map selectedVariation =
            state.selectedVariationsGroupedVariableProducts ?? {};

        isVariationSelected(int productID) {
          if (selectedVariation.containsKey(productID)) {
            return true;
          }
          return false;
        }

        String notSelectedVariableProducts = '';

        var variableProducts = products
            .where((element) => element.type == ProductType.variable)
            .toList();

        variableProducts
            .where((element) => !selectedVariation.containsKey(element.id))
            .forEach(
          (element) {
            notSelectedVariableProducts += "${element.name},";
          },
        );

        // ------------------------------------------ // ------------------------------------------ //

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BaseText(
              localization.products_collection,
              style: Theme.of(context).textTheme.headlineSmall!,
            ),
            verticalSpaceTiny,
            for (var i = 0; i < products.length; i++)
              Builder(
                builder: (context) {
                  var product = products[i];
                  String? image =
                      product.images.isNotEmpty ? product.images.first : null;
                  var price = product.type != ProductType.variable
                      ? product.price
                      : state
                              .selectedVariationsGroupedVariableProducts?[
                                  product.id]
                              ?.price ??
                          '0';
                  return GestureDetector(
                    onTap: () {
                      if (product.type == ProductType.variable) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((_) => BlocProvider.value(
                                  value: BlocProvider.of<ProductsBloc>(context),
                                  child: VariationSelectionPopup(
                                    product: product,
                                  ),
                                )),
                          ),
                        );
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                      margin: const EdgeInsets.only(bottom: 8.0),
                      height: screenWidthPercentage(context, percentage: .25),
                      width: double.infinity,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: kcSecondaryColor,
                            height:
                                screenWidthPercentage(context, percentage: .25),
                            width:
                                screenWidthPercentage(context, percentage: .25),
                            child: image != null
                                ? Image.network(image)
                                : const ResponsiveIcon(Icons.image),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BaseText(
                                      product.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!,
                                    ),
                                    verticalSpaceTiny,
                                    BaseText(
                                      "$price\$",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!,
                                    ),
                                  ],
                                ),
                                !isVariationSelected(product.id) &&
                                        variableProducts.any((element) =>
                                            element.id == product.id)
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: kcSecondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: BaseText(
                                            localization.select_variation,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!,
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            if (selectedVariation.length != variableProducts.length &&
                variableProducts.isNotEmpty)
              MessageAlert(
                message: localization.unselected_variation_message(
                    "( $notSelectedVariableProducts )"),
              )
          ],
        );
      },
    );
  }
}

class VariationSelectionPopup extends StatefulWidget {
  const VariationSelectionPopup({Key? key, required this.product})
      : super(key: key);
  final Product product;
  @override
  State<VariationSelectionPopup> createState() =>
      _VariationSelectionPopupState();
}

class _VariationSelectionPopupState extends State<VariationSelectionPopup> {
  var repo = locator<ProductsRepository>();
  late Future future;
  @override
  void initState() {
    future = repo.fetchVariations(widget.product.id);
    super.initState();
  }

  String? image;

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    var stockStatuses = {
      "instock": localization.instock,
      "outofstock": localization.outofstock
    };

    var height = screenHeight(context) -
        screenWidthPercentage(context, percentage: .5) -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;

    var product = widget.product;
    double ratePercentage = double.parse(product.averageRating) / 5;

    return Scaffold(
      appBar: AppBar(
          title: BaseText(
        localization.select_variation,
        style: Theme.of(context).textTheme.bodySmall!,
      )),
      body: FutureBuilder(
        future: future,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: kcPrimaryColor,
              ),
            );
          }
          List<ProductVariation> variations = snapshot.data!;
          var combinations = getCombinationAndAttributes(variations)[0];
          var attributes = getCombinationAndAttributes(variations)[1];
          return BlocBuilder<ProductsBloc, ProductsState>(
            builder: (context, state) {
              ProductVariation? selectedVariation =
                  state.selectedVariationsGroupedVariableProducts?[product.id];
              String price = selectedVariation?.price ?? '0';
              image = selectedVariation?.image;
              List<String>? selectedCombination =
                  selectedVariation?.attributes.map((e) => e.option).toList();
              return Column(
                children: [
                  Center(
                    child: Container(
                      color: kcSecondaryColor,
                      width: screenWidthPercentage(context, percentage: .5),
                      height: screenWidthPercentage(context, percentage: .5),
                      child: image != null
                          ? Image.network(image!)
                          : const ResponsiveIcon(Icons.image),
                    ),
                  ),
                  SizedBox(
                    height: height * .80,
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            verticalSpaceMedium,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: screenWidthPercentage(context,
                                              percentage: .85) -
                                          48,
                                      child: BaseText(
                                        product.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: kcSecondaryColor,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(6),
                                            child: BaseText(
                                              "${product.totalSales} ${localization.sold}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!,
                                            ),
                                          ),
                                        ),
                                        horizontalSpaceSmall,
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ReviewsScreen(
                                                        product: product),
                                              ),
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              ShaderMask(
                                                blendMode: BlendMode.srcIn,
                                                shaderCallback: (Rect bounds) =>
                                                    LinearGradient(
                                                  stops: [
                                                    ratePercentage,
                                                    ratePercentage
                                                  ],
                                                  colors: [
                                                    kcPrimaryColor,
                                                    kcSecondaryColor,
                                                  ],
                                                ).createShader(bounds),
                                                child: const ResponsiveIcon(
                                                    IconlyBold.star),
                                              ),
                                              horizontalSpaceTiny,
                                              BaseText(
                                                "${product.averageRating} (${product.ratingCount})",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!,
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    verticalSpaceTiny,
                                    BaseText(
                                      stockStatuses[product.stockStatus] ??
                                          product.stockStatus,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!,
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    FavoriteButton(product: product),
                                    IconButton(
                                      onPressed: () {
                                        Share.share(product.permalink);
                                      },
                                      icon: const ResponsiveIcon(Icons.share),
                                    )
                                  ],
                                )
                              ],
                            ),
                            AttributesSection(
                              attributes: attributes,
                              combinations: combinations,
                              product: product,
                              variations: variations,
                              selectedCombination: selectedCombination,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(color: kcSecondaryColor),
                                BaseText(
                                  localization.description,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!,
                                ),
                                verticalSpaceTiny,
                                Html(
                                  data: product.description,
                                  style: {
                                    'div': Style(
                                      fontSize: FontSize(
                                        Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .fontSize! *
                                            (screenWidth(context) / 3.5) /
                                            100,
                                      ),
                                      padding: const EdgeInsets.all(0),
                                      margin: const EdgeInsets.all(0),
                                    ),
                                    'p': Style(
                                      padding: const EdgeInsets.all(0),
                                      margin: const EdgeInsets.all(0),
                                      fontSize: FontSize(
                                        Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .fontSize! *
                                            (screenWidth(context) / 3.5) /
                                            100,
                                      ),
                                    )
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: kcSecondaryColor,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: kcSecondaryColor),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BaseText(
                                    localization.total_price,
                                    style:
                                        Theme.of(context).textTheme.titleSmall!,
                                  ),
                                  BaseText(
                                    '$price\$',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!,
                                  )
                                ],
                              ),
                              horizontalSpaceRegular,
                              Expanded(
                                child: BaseButton(
                                  title: localization.confirm,
                                  callback: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          );
        }),
      ),
    );
  }
}
