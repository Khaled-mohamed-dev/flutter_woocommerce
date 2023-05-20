import 'package:equatable/equatable.dart';

import '../../data/models/cart_item.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCartItems extends CartEvent {}

class ClearCartItems extends CartEvent {}

class IncrementQuantity extends CartEvent {
  final CartItem cartItem;

  IncrementQuantity({required this.cartItem});

  @override
  List<Object?> get props => [cartItem];
}

class DecrementQuantity extends CartEvent {
  final CartItem cartItem;

  DecrementQuantity({required this.cartItem});

  @override
  List<Object?> get props => [cartItem];
}

class RemoveItemFromCart extends CartEvent {
  final CartItem cartItem;

  RemoveItemFromCart({required this.cartItem});

  @override
  List<Object?> get props => [cartItem];
}

class UpdateCartItem extends CartEvent {
  final CartItem cartItem;

  UpdateCartItem({required this.cartItem});

  @override
  List<Object?> get props => [cartItem];
}
