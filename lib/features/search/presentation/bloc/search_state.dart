import 'package:equatable/equatable.dart';
import 'package:flutter_woocommerce/features/search/data/models/search_params.dart';
import '../../../product/data/models/product.dart';

enum SearchStatus { loading, initial, success, failure }

class SearchState extends Equatable {
  const SearchState({
    this.productsHasReachedMax = false,
    this.enableFilters = false,
    this.status = SearchStatus.initial,
    this.searchParmas = const SearchParmas(query: ''),
    this.isLoading = false,
    this.products = const [],
    this.isLoadingMoreProducts = false,
  });

  final SearchStatus status;
  final SearchParmas searchParmas;
  final bool enableFilters;
  final bool isLoading;
  final List<Product> products;
  final bool isLoadingMoreProducts;
  final bool productsHasReachedMax;

  SearchState copyWith({
    SearchStatus? status,
    SearchParmas? searchParmas,
    bool? enableFilters,
    List<Product>? products,
    bool? isLoadingMoreProducts,
    bool? productsHasReachedMax,
  }) {
    return SearchState(
        status: status ?? this.status,
        enableFilters: enableFilters ?? this.enableFilters,
        searchParmas: searchParmas ?? this.searchParmas,
        products: products ?? this.products,
        isLoadingMoreProducts:
            isLoadingMoreProducts ?? this.isLoadingMoreProducts,
        productsHasReachedMax:
            productsHasReachedMax ?? this.productsHasReachedMax);
  }

  @override
  String toString() {
    return '''SearchState { status: $status, params:  $searchParmas}''';
  }

  @override
  List<Object> get props => [
        status,
        enableFilters,
        searchParmas,
        products,
        isLoadingMoreProducts,
      ];
}
