import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_woocommerce/core/consts.dart';
import 'package:flutter_woocommerce/core/error/failures.dart';
import 'package:flutter_woocommerce/features/cart/data/models/cart_item.dart';
import 'package:flutter_woocommerce/main.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;

abstract class CartRepository {
  Future<Either<Failure, List<CartItem>>> getCartItems();

  Future clearCartItems();

  Future addCartItem(CartItem cartItem);

  Future removeCartItem(CartItem cartItem);

  Future updateCartItem(CartItem cartItem);
}

class CartRepositoryImpl implements CartRepository {
  final Box<CartItem> cartBox;

  final http.Client client;

  CartRepositoryImpl({required this.cartBox, required this.client});

  @override
  Future addCartItem(CartItem cartItem) async {
    late String key;
    if (cartItem.variationID != null) {
      key = "${cartItem.productID}:${cartItem.variationID}";
    } else {
      key = cartItem.productID.toString();
    }

    if (cartBox.containsKey(key)) {
      CartItem oldCartItem = cartBox.get(key)!;
      await cartBox.put(
        key,
        oldCartItem.copyWith(
          quantity: oldCartItem.quantity + cartItem.quantity,
        ),
      );
    } else {
      await cartBox.put(key, cartItem);
    }
  }

  @override
  Future clearCartItems() async {
    await cartBox.clear();
  }

  @override
  Future<Either<Failure, List<CartItem>>> getCartItems() async {
    try {
      // This function is there to make sure that the price stay of the cart item is the same price in the store
      // for example if the price of the product increased in the main website but the product has been in the cart for a long time this can cause difference in prices
      // between the app and the website thus creates issues
      final stopwatch = Stopwatch()..start();

      List<CartItem> cartItems = [];

      List<Future> futures = cartBox.values.map(
        (cartItem) {
          var productID = cartItem.productID;
          if (cartItem.variationID != null) {
            return client.get(
              Uri.parse(
                  '${wcAPI}products/$productID/variations/${cartItem.variationID}?$wcCred'),
            );
          } else {
            return client.get(Uri.parse('${wcAPI}products/$productID?$wcCred'));
          }
        },
      ).toList();

      var results = await Future.wait(futures);

      if (results
          .any(((result) => errorStatusCodes.contains(result.statusCode)))) {
        logger.e(results
            .firstWhere(
                (result) => errorStatusCodes.contains(result.statusCode))
            .body);
        return Left(ServerFailure());
      }

      for (var i = 0; i < cartBox.length; i++) {
        late String productPrice;

        var cartItem = cartBox.values.toList()[i];

        if (cartItem.variationID != null) {
          productPrice = json.decode(results[i].body)['price'].toString();
        } else {
          productPrice = json.decode(results[i].body)['price'].toString();
        }

        cartItems.add(
          cartItem.copyWith(
            productPrice: productPrice,
          ),
        );
      }

      logger.wtf('function executed in ${stopwatch.elapsed}');

      stopwatch.stop();

      return Right(cartItems);
    } catch (e) {
      logger.wtf(e);
      return Left(ServerFailure());
    }
  }

  @override
  Future removeCartItem(CartItem cartItem) async {
    late String key;
    if (cartItem.variationID != null) {
      // This deals with variable products
      key = "${cartItem.productID}:${cartItem.variationID}";
    } else {
      key = cartItem.productID.toString();
    }

    await cartBox.delete(key);
  }

  @override
  Future updateCartItem(CartItem cartItem) async {
    late String key;
    if (cartItem.variationID != null) {
      // This deals with variable products
      key = "${cartItem.productID}:${cartItem.variationID}";
    } else {
      key = cartItem.productID.toString();
    }

    await cartBox.put(key, cartItem);
  }
}
