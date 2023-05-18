import 'package:equatable/equatable.dart';
import '../../../product/data/models/product.dart';

enum CategoryStatus { initial, success, failure }

class CategoryState extends Equatable {
  const CategoryState({
    this.productsHasReachedMax = false,
    this.status = CategoryStatus.initial,
    this.products = const [],
    this.isLoadingMoreProducts = false,
  });

  final CategoryStatus status;
  final List<Product> products;
  final bool isLoadingMoreProducts;

  final bool productsHasReachedMax;

  CategoryState copyWith({
    CategoryStatus? status,
    List<Product>? products,
    bool? isLoadingMoreProducts,
    bool? productsHasReachedMax,
  }) {
    return CategoryState(
        status: status ?? this.status,
        products: products ?? this.products,
        isLoadingMoreProducts:
            isLoadingMoreProducts ?? this.isLoadingMoreProducts,
        productsHasReachedMax:
            productsHasReachedMax ?? this.productsHasReachedMax);
  }

  @override
  String toString() {
    return '''CategoryState { status: $status, response: }''';
  }

  @override
  List<Object> get props => [
        status,
        products,
        isLoadingMoreProducts,
      ];
}
