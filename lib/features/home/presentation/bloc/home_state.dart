import 'package:equatable/equatable.dart';
import '../../../product/data/models/product.dart';
import '../../../category/data/models/category.dart';

enum HomeStatus { initial, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.productsHasReachedMax = false,
    this.categoriesHasReachedMax = false,
    this.status = HomeStatus.initial,
    this.products = const [],
    this.isLoadingMoreProducts = false,
    this.categories = const [],
  });

  final HomeStatus status;
  final List<Product> products;
  final bool isLoadingMoreProducts;
  final List<Category> categories;

  final bool productsHasReachedMax;
  final bool categoriesHasReachedMax;

  HomeState copyWith({
    HomeStatus? status,
    List<Product>? products,
    bool? isLoadingMoreProducts,
    List<Category>? categories,
    bool? productsHasReachedMax,
    bool? categoriesHasReachedMax,
  }) {
    return HomeState(
        status: status ?? this.status,
        products: products ?? this.products,
        isLoadingMoreProducts:
            isLoadingMoreProducts ?? this.isLoadingMoreProducts,
        categories: categories ?? this.categories,
        categoriesHasReachedMax:
            categoriesHasReachedMax ?? this.categoriesHasReachedMax,
        productsHasReachedMax:
            productsHasReachedMax ?? this.productsHasReachedMax);
  }

  @override
  String toString() {
    return '''HomeState { status: $status, response: }''';
  }

  @override
  List<Object> get props => [
        status,
        categories,
        products,
        isLoadingMoreProducts,
      ];
}
