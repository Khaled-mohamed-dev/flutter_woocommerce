import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadHome extends HomeEvent {}

class FetchMoreProducts extends HomeEvent {}

class FetchMoreCategories extends HomeEvent {}
