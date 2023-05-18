import 'package:equatable/equatable.dart';
import 'package:flutter_woocommerce/features/product/data/models/product.dart';
import 'package:flutter_woocommerce/features/product/data/models/product_variation.dart';

enum ProductsStatus { initial, success, failure }

class ProductsState extends Equatable {
  final ProductsStatus status;
  // This is for additional info that the grouped and variable product need
  final int qunatity;
  final String price;

  // grouped products properties
  final List<Product>? groupedProducts;
  final Map? selectedVariationsGroupedVariableProducts;

  // variable product properties
  final ProductVariation? selectedVariation;
  final Map<String, dynamic>? combinations;
  final Map? attributes;
  final String? variationImage;

  const ProductsState({
    this.status = ProductsStatus.initial,
    this.qunatity = 1,
    this.price = '0',
    // grouped products properties
    this.groupedProducts,
    this.selectedVariationsGroupedVariableProducts,
    // variable product
    this.variationImage,
    this.selectedVariation,
    this.attributes,
    this.combinations,
  });

  @override
  String toString() {
    return '''ProductsState { status: $status }''';
  }

  ProductsState copyWith({
    ProductsStatus? status,
    int? qunatity,
    String? price,
    List<Product>? groupedProducts,
    Map? selectedVariationsGroupedVariableProducts,
    ProductVariation? selectedVariation,
    String? variationImage,
    Map<String, dynamic>? combinations,
    Map? attributes,
  }) =>
      ProductsState(
        status: status ?? this.status,
        qunatity: qunatity ?? this.qunatity,
        price: price ?? this.price,
        groupedProducts: groupedProducts ?? this.groupedProducts,
        selectedVariationsGroupedVariableProducts:
            selectedVariationsGroupedVariableProducts ??
                this.selectedVariationsGroupedVariableProducts,
        selectedVariation: selectedVariation,
        variationImage: variationImage,
        combinations: combinations ?? this.combinations,
        attributes: attributes ?? this.attributes,
      );

  @override
  List<Object?> get props => [
        status,
        qunatity,
        price,
        groupedProducts,
        selectedVariationsGroupedVariableProducts,
        selectedVariation,
        variationImage,
        attributes,
        combinations
      ];
}
