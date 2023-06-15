import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_woocommerce/core/error/failures.dart';
import 'package:flutter_woocommerce/features/product/data/models/product.dart';
import 'package:flutter_woocommerce/features/product/data/models/product_variation.dart';

import '../../../../core/consts.dart';
import '../../../../main.dart';
import 'package:http/http.dart' as http;

abstract class ProductsRepository {
  Future<Either<Failure, List<Product>>> fetchGroupedProducts(
      List<int> productsIDs);
  Future<Either<Failure, List<ProductVariation>>> fetchProductVariations(
      int productID);
  Future<List<ProductVariation>?> fetchVariations(int productID);
  Future<Product> retrieveSinleProduct(int productID);
}

class ProductsRepositoryImpl implements ProductsRepository {
  final http.Client client;

  ProductsRepositoryImpl({required this.client});

  @override
  Future<Either<Failure, List<Product>>> fetchGroupedProducts(
      List<int> productsIDs) async {
    var include =
        productsIDs.toString().replaceAll('[', '').replaceAll(']', '');
    try {
      var response = await client
          .get(Uri.parse('${wcAPI}products?include=$include&$wcCred'));

      if (errorStatusCodes.contains(response.statusCode)) {
        logger.e(response.body);
        return Left(ServerFailure());
      }

      var result = productFromJson(response.body);
      logger.wtf(result);
      return Right(result);
    } catch (e) {
      logger.e('$e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ProductVariation>>> fetchProductVariations(
      int productID) async {
    try {
      final stopwatch = Stopwatch()..start();

      var response = await client.get(Uri.parse(
          '${wcAPI}products/$productID/variations?per_page=100&$wcCred'));

      if (errorStatusCodes.contains(response.statusCode)) {
        logger.e(response.body);
        return Left(ServerFailure());
      }

      var result = productVariationFromJson(response.body);

      logger.w('function executed in ${stopwatch.elapsed}');

      stopwatch.stop();

      return Right(result);
    } catch (e) {
      logger.e('$e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<List<ProductVariation>?> fetchVariations(int productID) async {
    var response = await client.get(
      Uri.parse('${wcAPI}products/$productID/variations?per_page=100&$wcCred'),
    );
    var result = productVariationFromJson(response.body);
    return result;
  }

  @override
  Future<Product> retrieveSinleProduct(int productID) async {
    var response = await client.get(
      Uri.parse('${wcAPI}products/$productID?$wcCred'),
    );
    var result = Product.fromJson(json.decode(response.body));
    return result;
  }
}
