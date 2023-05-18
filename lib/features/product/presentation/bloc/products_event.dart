import 'package:equatable/equatable.dart';
import 'package:flutter_woocommerce/features/product/data/models/product.dart';
import 'package:flutter_woocommerce/features/product/data/models/product_variation.dart';

abstract class ProductsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitPage extends ProductsEvent {
  final Product product;
  InitPage(this.product);

  @override
  List<Object> get props => [product];
}

class IncrementQuantity extends ProductsEvent {}

class DecrementQuantity extends ProductsEvent {}

class HandleButtonClick extends ProductsEvent {
  final Product product;
  HandleButtonClick(this.product);

  @override
  List<Object> get props => [product];
}

// for variable products
class ChooseOptions extends ProductsEvent {}

class SelectCombination extends ProductsEvent {
  final List selectedCombination;
  final List<ProductVariation>? variations;
  final Product? product;
  SelectCombination(this.selectedCombination, {this.variations, this.product});
}
