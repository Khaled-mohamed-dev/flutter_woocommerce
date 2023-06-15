import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_woocommerce/features/cart/data/repositories/cart_repository.dart';
import 'package:flutter_woocommerce/features/cart/presentation/bloc/bloc.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/cart_item.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc({required this.cartRepository})
      : super(const CartState(status: CartStatus.initial)) {
    on<LoadCartItems>(
      (event, emit) async {
        Either<Failure, List<CartItem>> faliureOrResopnse =
            await cartRepository.getCartItems();
        return faliureOrResopnse.fold(
          (l) => emit(state.copyWith(status: CartStatus.failure)),
          (r) => emit(
            state.copyWith(status: CartStatus.success, cartItems: r),
          ),
        );
      },
    );

    on<RemoveItemFromCart>(
      (event, emit) {
        cartRepository.removeCartItem(event.cartItem);
        var f = List.of(state.cartItems);
        f.remove(event.cartItem);
      },
    );

    on<DecrementQuantity>(
      (event, emit) {
        if (event.cartItem.quantity > 1) {
          var updatedCartItem =
              event.cartItem.copyWith(quantity: event.cartItem.quantity - 1);
          cartRepository.updateCartItem(updatedCartItem);
        }
      },
    );

    on<IncrementQuantity>(
      (event, emit) {
        var updatedCartItem =
            event.cartItem.copyWith(quantity: event.cartItem.quantity + 1);
        cartRepository.updateCartItem(updatedCartItem);
      },
    );

    on<ClearCartItems>((event, emit) => cartRepository.clearCartItems());
  }
}
