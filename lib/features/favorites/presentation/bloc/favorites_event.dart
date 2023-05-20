import 'package:equatable/equatable.dart';
import 'package:flutter_woocommerce/features/product/data/models/product.dart';

abstract class FavoritesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadFavorites extends FavoritesEvent {}

class FetchMoreProducts extends FavoritesEvent {}

class ChangeFavoriteStatus extends FavoritesEvent {
  final Product product;

  ChangeFavoriteStatus(this.product);
}

class DisposeFavorites extends FavoritesEvent {}



