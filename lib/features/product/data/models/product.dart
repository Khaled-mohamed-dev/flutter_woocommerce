// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';
import 'package:html_unescape/html_unescape.dart';

import 'package:equatable/equatable.dart';

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.permalink,
    required this.type,
    required this.status,
    required this.featured,
    required this.catalogVisibility,
    required this.description,
    required this.shortDescription,
    required this.price,
    required this.htmlPrice,
    required this.regularPrice,
    required this.salePrice,
    this.dateOnSaleFrom,
    this.dateOnSaleTo,
    required this.onSale,
    required this.purchasable,
    required this.totalSales,
    required this.manageStock,
    this.stockQuantity,
    required this.stockStatus,
    required this.backorders,
    required this.backordersAllowed,
    required this.backordered,
    required this.soldIndividually,
    required this.weight,
    required this.dimensions,
    required this.shippingRequired,
    required this.reviewsAllowed,
    required this.averageRating,
    required this.ratingCount,
    required this.relatedIds,
    required this.upsellIds,
    required this.crossSellIds,
    required this.parentId,
    required this.purchaseNote,
    required this.categories,
    required this.tags,
    required this.images,
    required this.attributes,
    required this.defaultAttributes,
    required this.variations,
    required this.groupedProducts,
    required this.menuOrder,
    required this.metaData,
    required this.externalUrl,
    required this.buttonText,
  });

  final int id;
  final String name;
  final String slug;
  final String permalink;
  final ProductType type;
  final String status;
  final bool featured;
  final String catalogVisibility;
  final String description;
  final String shortDescription;
  final String price;
  final String htmlPrice;
  final String regularPrice;
  final String salePrice;
  final dynamic dateOnSaleFrom;
  final dynamic dateOnSaleTo;
  final bool onSale;
  final bool purchasable;
  final int totalSales;
  final bool manageStock;
  final dynamic stockQuantity;
  final String stockStatus;
  final String backorders;
  final bool backordersAllowed;
  final bool backordered;
  final bool soldIndividually;
  final String weight;
  final Dimensions dimensions;
  final bool shippingRequired;
  final bool reviewsAllowed;
  final String averageRating;
  final int ratingCount;
  final List<int> relatedIds;
  final List<dynamic> upsellIds;
  final List<dynamic> crossSellIds;
  final int parentId;
  final String purchaseNote;
  final List<CategoryRef> categories;
  final List<dynamic> tags;
  final List<String> images;
  final List<dynamic> attributes;
  final List<dynamic> defaultAttributes;
  final List<dynamic> variations;
  final List<dynamic> groupedProducts;
  final int menuOrder;
  final List<dynamic> metaData;
  final String externalUrl;
  final String buttonText;
  Product copyWith({
    int? id,
    String? name,
    String? slug,
    String? permalink,
    ProductType? type,
    String? status,
    bool? featured,
    String? catalogVisibility,
    String? description,
    String? shortDescription,
    String? price,
    String? htmlPrice,
    String? regularPrice,
    String? salePrice,
    dynamic dateOnSaleFrom,
    dynamic dateOnSaleTo,
    bool? onSale,
    bool? purchasable,
    int? totalSales,
    bool? manageStock,
    dynamic stockQuantity,
    String? stockStatus,
    String? backorders,
    bool? backordersAllowed,
    bool? backordered,
    bool? soldIndividually,
    String? weight,
    Dimensions? dimensions,
    bool? shippingRequired,
    bool? reviewsAllowed,
    String? averageRating,
    int? ratingCount,
    List<int>? relatedIds,
    List<dynamic>? upsellIds,
    List<dynamic>? crossSellIds,
    int? parentId,
    String? purchaseNote,
    List<CategoryRef>? categories,
    List<dynamic>? tags,
    List<String>? images,
    List<dynamic>? attributes,
    List<dynamic>? defaultAttributes,
    List<dynamic>? variations,
    List<dynamic>? groupedProducts,
    int? menuOrder,
    List<dynamic>? metaData,
    String? externalUrl,
    String? buttonText,
  }) =>
      Product(
        id: id ?? this.id,
        name: name ?? this.name,
        slug: slug ?? this.slug,
        permalink: permalink ?? this.permalink,
        type: type ?? this.type,
        status: status ?? this.status,
        featured: featured ?? this.featured,
        catalogVisibility: catalogVisibility ?? this.catalogVisibility,
        description: description ?? this.description,
        shortDescription: shortDescription ?? this.shortDescription,
        price: price ?? this.price,
        htmlPrice: htmlPrice ?? this.htmlPrice,
        regularPrice: regularPrice ?? this.regularPrice,
        salePrice: salePrice ?? this.salePrice,
        dateOnSaleFrom: dateOnSaleFrom ?? this.dateOnSaleFrom,
        dateOnSaleTo: dateOnSaleTo ?? this.dateOnSaleTo,
        onSale: onSale ?? this.onSale,
        purchasable: purchasable ?? this.purchasable,
        totalSales: totalSales ?? this.totalSales,
        manageStock: manageStock ?? this.manageStock,
        stockQuantity: stockQuantity ?? this.stockQuantity,
        stockStatus: stockStatus ?? this.stockStatus,
        backorders: backorders ?? this.backorders,
        backordersAllowed: backordersAllowed ?? this.backordersAllowed,
        backordered: backordered ?? this.backordered,
        soldIndividually: soldIndividually ?? this.soldIndividually,
        weight: weight ?? this.weight,
        dimensions: dimensions ?? this.dimensions,
        shippingRequired: shippingRequired ?? this.shippingRequired,
        reviewsAllowed: reviewsAllowed ?? this.reviewsAllowed,
        averageRating: averageRating ?? this.averageRating,
        ratingCount: ratingCount ?? this.ratingCount,
        relatedIds: relatedIds ?? this.relatedIds,
        upsellIds: upsellIds ?? this.upsellIds,
        crossSellIds: crossSellIds ?? this.crossSellIds,
        parentId: parentId ?? this.parentId,
        purchaseNote: purchaseNote ?? this.purchaseNote,
        categories: categories ?? this.categories,
        tags: tags ?? this.tags,
        images: images ?? this.images,
        attributes: attributes ?? this.attributes,
        defaultAttributes: defaultAttributes ?? this.defaultAttributes,
        variations: variations ?? this.variations,
        groupedProducts: groupedProducts ?? this.groupedProducts,
        menuOrder: menuOrder ?? this.menuOrder,
        metaData: metaData ?? this.metaData,
        externalUrl: externalUrl ?? this.externalUrl,
        buttonText: buttonText ?? this.buttonText,
      );

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        permalink: json["permalink"],
        type: getProductType(json["type"]),
        status: json["status"],
        featured: json["featured"],
        catalogVisibility: json["catalog_visibility"],
        description: json["description"],
        shortDescription: json["short_description"],
        price: json["price"],
        htmlPrice: formatHtmlPrice(json['price_html']),
        regularPrice: json["regular_price"],
        salePrice: json["sale_price"],
        dateOnSaleFrom: json["date_on_sale_from"],
        dateOnSaleTo: json["date_on_sale_to"],
        onSale: json["on_sale"],
        purchasable: json["purchasable"],
        totalSales: json["total_sales"] is String
            ? int.parse(json["total_sales"])
            : json["total_sales"],
        manageStock: json["manage_stock"],
        stockQuantity: json["stock_quantity"],
        stockStatus: json["stock_status"],
        backorders: json["backorders"],
        backordersAllowed: json["backorders_allowed"],
        backordered: json["backordered"],
        soldIndividually: json["sold_individually"],
        weight: json["weight"],
        dimensions: Dimensions.fromJson(json["dimensions"]),
        shippingRequired: json["shipping_required"],
        reviewsAllowed: json["reviews_allowed"],
        averageRating: json["average_rating"],
        ratingCount: json["rating_count"],
        relatedIds: List<int>.from(json["related_ids"].map((x) => x)),
        upsellIds: List<dynamic>.from(json["upsell_ids"].map((x) => x)),
        crossSellIds: List<dynamic>.from(json["cross_sell_ids"].map((x) => x)),
        parentId: json["parent_id"],
        purchaseNote: json["purchase_note"],
        categories: List<CategoryRef>.from(
            json["categories"].map((x) => CategoryRef.fromJson(x))),
        tags: List<dynamic>.from(json["tags"].map((x) => x)),
        images: List<String>.from(json["images"].map((x) => x['src'])),
        attributes: List<dynamic>.from(json["attributes"].map((x) => x)),
        defaultAttributes:
            List<dynamic>.from(json["default_attributes"].map((x) => x)),
        variations: List<dynamic>.from(json["variations"].map((x) => x)),
        groupedProducts:
            List<dynamic>.from(json["grouped_products"].map((x) => x)),
        menuOrder: json["menu_order"],
        metaData: List<dynamic>.from(json["meta_data"].map((x) => x)),
        externalUrl: json['external_url'],
        buttonText: json['button_text'],
      );

  @override
  List<Object?> get props => [id, images];
}

class CategoryRef {
  CategoryRef({
    required this.id,
    required this.name,
    required this.slug,
  });

  final int id;
  final String name;
  final String slug;

  CategoryRef copyWith({
    int? id,
    String? name,
    String? slug,
  }) =>
      CategoryRef(
        id: id ?? this.id,
        name: name ?? this.name,
        slug: slug ?? this.slug,
      );

  factory CategoryRef.fromJson(Map<String, dynamic> json) => CategoryRef(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
      );
}

class Dimensions {
  Dimensions({
    required this.length,
    required this.width,
    required this.height,
  });

  final String length;
  final String width;
  final String height;

  Dimensions copyWith({
    String? length,
    String? width,
    String? height,
  }) =>
      Dimensions(
        length: length ?? this.length,
        width: width ?? this.width,
        height: height ?? this.height,
      );

  factory Dimensions.fromJson(Map<String, dynamic> json) => Dimensions(
        length: json["length"],
        width: json["width"],
        height: json["height"],
      );
}

enum ProductType {
  simple,
  grouped,
  external,
  variable,
}

ProductType getProductType(String type) {
  switch (type) {
    case 'simple':
      return ProductType.simple;
    case 'grouped':
      return ProductType.grouped;
    case 'external':
      return ProductType.external;
    case 'variable':
      return ProductType.variable;
    default:
      return ProductType.simple;
  }
}

String formatHtmlPrice(String htmlPrice) {
  String result = '';
  RegExp regExp = RegExp(r'(?<=\>)(.*?)(?=\<)');
  var matchess = regExp.allMatches(htmlPrice);
  for (var match in matchess) {
    result += match.group(0)!;
  }

  return HtmlUnescape().convert(result);
}
