import 'package:equatable/equatable.dart';
import 'package:flutter_woocommerce/features/cart/data/models/cart_item.dart';

enum CartStatus { initial, success, failure }

class CartState extends Equatable {
  const CartState(
      {this.status = CartStatus.initial, this.cartItems = const []});

  final CartStatus status;
  final List<CartItem> cartItems;

  CartState copyWith({CartStatus? status, List<CartItem>? cartItems}) {
    return CartState(
      status: status ?? this.status,
      cartItems: cartItems ?? this.cartItems,
    );
  }

  @override
  String toString() {
    return '''CartState { status: $status, response: }''';
  }

  @override
  List<Object> get props => [status, cartItems];
}
