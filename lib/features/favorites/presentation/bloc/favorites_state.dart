import 'package:equatable/equatable.dart';
import '../../../product/data/models/product.dart';

enum FavoritesStatus { initial, success, failure }

class FavoritesState extends Equatable {
  const FavoritesState({
    this.productsHasReachedMax = false,
    this.favoritesIDs = const [],
    this.status = FavoritesStatus.initial,
    this.products = const [],
    this.isLoadingMoreProducts = false,
  });

  final FavoritesStatus status;
  final List<String> favoritesIDs;
  final List<Product> products;
  final bool isLoadingMoreProducts;
  final bool productsHasReachedMax;

  FavoritesState copyWith({
    FavoritesStatus? status,
    List<Product>? products,
    List<String>? favoritesIDs,
    bool? isLoadingMoreProducts,
    bool? productsHasReachedMax,
  }) {
    return FavoritesState(
        status: status ?? this.status,
        products: products ?? this.products,
        favoritesIDs: favoritesIDs ?? this.favoritesIDs,
        isLoadingMoreProducts:
            isLoadingMoreProducts ?? this.isLoadingMoreProducts,
        productsHasReachedMax:
            productsHasReachedMax ?? this.productsHasReachedMax);
  }

  @override
  String toString() {
    return '''FavoritesState { status: $status, response: }''';
  }

  @override
  List<Object?> get props => [
        status,
        products,
        productsHasReachedMax,
        isLoadingMoreProducts,
        favoritesIDs,
      ];
}
