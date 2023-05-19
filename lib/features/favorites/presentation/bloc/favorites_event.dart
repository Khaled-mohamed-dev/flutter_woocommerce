import 'package:equatable/equatable.dart';

abstract class FavoritesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadFavorites extends FavoritesEvent {}

class FetchMoreProducts extends FavoritesEvent {}
