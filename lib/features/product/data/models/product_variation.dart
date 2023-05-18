// To parse this JSON data, do
//
//     final productVariation = productVariationFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

List<ProductVariation> productVariationFromJson(String str) =>
    List<ProductVariation>.from(
        json.decode(str).map((x) => ProductVariation.fromJson(x)));

class ProductVariation {
  ProductVariation({
    required this.id,
    required this.dateCreated,
    required this.dateModified,
    required this.description,
    required this.permalink,
    required this.price,
    required this.regularPrice,
    required this.salePrice,
    this.dateOnSaleFrom,
    this.dateOnSaleTo,
    required this.onSale,
    required this.status,
    required this.purchasable,
    required this.manageStock,
    this.stockQuantity,
    required this.stockStatus,
    required this.backorders,
    required this.backordersAllowed,
    required this.backordered,
    required this.weight,
    required this.dimensions,
    required this.shippingClass,
    required this.shippingClassId,
    required this.image,
    required this.attributes,
    required this.menuOrder,
    required this.metaData,
  });

  final int id;
  final DateTime dateCreated;
  final DateTime dateModified;
  final String description;
  final String permalink;
  final String price;
  final String regularPrice;
  final String salePrice;
  final dynamic dateOnSaleFrom;
  final dynamic dateOnSaleTo;
  final bool onSale;
  final String status;
  final bool purchasable;
  final bool manageStock;
  final dynamic stockQuantity;
  final String stockStatus;
  final String backorders;
  final bool backordersAllowed;
  final bool backordered;
  final String weight;
  final Dimensions dimensions;
  final String shippingClass;
  final int shippingClassId;
  final String? image;
  final List<Attribute> attributes;
  final int menuOrder;
  final List<dynamic> metaData;

  ProductVariation copyWith({
    int? id,
    DateTime? dateCreated,
    DateTime? dateModified,
    String? description,
    String? permalink,
    String? price,
    String? regularPrice,
    String? salePrice,
    dynamic dateOnSaleFrom,
    dynamic dateOnSaleTo,
    bool? onSale,
    String? status,
    bool? purchasable,
    bool? manageStock,
    dynamic stockQuantity,
    String? stockStatus,
    String? backorders,
    bool? backordersAllowed,
    bool? backordered,
    String? weight,
    Dimensions? dimensions,
    String? shippingClass,
    int? shippingClassId,
    String? image,
    List<Attribute>? attributes,
    int? menuOrder,
    List<dynamic>? metaData,
  }) =>
      ProductVariation(
        id: id ?? this.id,
        dateCreated: dateCreated ?? this.dateCreated,
        dateModified: dateModified ?? this.dateModified,
        description: description ?? this.description,
        permalink: permalink ?? this.permalink,
        price: price ?? this.price,
        regularPrice: regularPrice ?? this.regularPrice,
        salePrice: salePrice ?? this.salePrice,
        dateOnSaleFrom: dateOnSaleFrom ?? this.dateOnSaleFrom,
        dateOnSaleTo: dateOnSaleTo ?? this.dateOnSaleTo,
        onSale: onSale ?? this.onSale,
        status: status ?? this.status,
        purchasable: purchasable ?? this.purchasable,
        manageStock: manageStock ?? this.manageStock,
        stockQuantity: stockQuantity ?? this.stockQuantity,
        stockStatus: stockStatus ?? this.stockStatus,
        backorders: backorders ?? this.backorders,
        backordersAllowed: backordersAllowed ?? this.backordersAllowed,
        backordered: backordered ?? this.backordered,
        weight: weight ?? this.weight,
        dimensions: dimensions ?? this.dimensions,
        shippingClass: shippingClass ?? this.shippingClass,
        shippingClassId: shippingClassId ?? this.shippingClassId,
        image: image ?? this.image,
        attributes: attributes ?? this.attributes,
        menuOrder: menuOrder ?? this.menuOrder,
        metaData: metaData ?? this.metaData,
      );

  factory ProductVariation.fromJson(Map<String, dynamic> json) =>
      ProductVariation(
        id: json["id"],
        dateCreated: DateTime.parse(json["date_created"]),
        dateModified: DateTime.parse(json["date_modified"]),
        description: json["description"],
        permalink: json["permalink"],
        price: json["price"],
        regularPrice: json["regular_price"],
        salePrice: json["sale_price"],
        dateOnSaleFrom: json["date_on_sale_from"],
        dateOnSaleTo: json["date_on_sale_to"],
        onSale: json["on_sale"],
        status: json["status"],
        purchasable: json["purchasable"],
        manageStock: json["manage_stock"],
        stockQuantity: json["stock_quantity"],
        stockStatus: json["stock_status"],
        backorders: json["backorders"],
        backordersAllowed: json["backorders_allowed"],
        backordered: json["backordered"],
        weight: json["weight"],
        dimensions: Dimensions.fromJson(json["dimensions"]),
        shippingClass: json["shipping_class"],
        shippingClassId: json["shipping_class_id"],
        image: json["image"] == null ? null : json["image"]['src'],
        attributes: List<Attribute>.from(
            json["attributes"].map((x) => Attribute.fromJson(x))),
        menuOrder: json["menu_order"],
        metaData: List<dynamic>.from(json["meta_data"].map((x) => x)),
      );
}

class Attribute extends Equatable {
  const Attribute({
    required this.id,
    required this.name,
    required this.option,
  });

  final int id;
  final String name;
  final String option;

  Attribute copyWith({
    int? id,
    String? name,
    String? option,
  }) =>
      Attribute(
        id: id ?? this.id,
        name: name ?? this.name,
        option: option ?? this.option,
      );

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
        id: json["id"],
        name: json["name"],
        option: json["option"],
      );

  @override
  List<Object?> get props => [id];
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
