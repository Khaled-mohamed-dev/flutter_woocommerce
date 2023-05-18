import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_woocommerce/core/error/failures.dart';
import 'package:flutter_woocommerce/features/product/data/models/product.dart';
import 'package:flutter_woocommerce/features/product/data/models/product_variation.dart';

import '../../../../core/consts.dart';
import '../../../../main.dart';

abstract class ProductsRepository {
  Future<Either<Failure, List<Product>>> fetchGroupedProducts(
      List<int> productsIDs);
  Future<Either<Failure, List<ProductVariation>>> fetchProductVariations(
      int productID);
  Future<List<ProductVariation>?> fetchVariations(int productID);
}

class ProductsRepositoryImpl implements ProductsRepository {
  final Dio dio;

  ProductsRepositoryImpl({required this.dio});

  @override
  Future<Either<Failure, List<Product>>> fetchGroupedProducts(
      List<int> productsIDs) async {
    var include =
        productsIDs.toString().replaceAll('[', '').replaceAll(']', '');
    try {
      var response = await dio.get(
        '${wcAPI}products?include=$include&$wcCred',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
          responseType: ResponseType.plain,
        ),
      );

      if (errorStatusCodes.contains(response.statusCode)) {
        logger.e(response.data);
        return Left(ServerFailure());
      }

      var result = productFromJson(response.data);
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

      var response = await dio.get(
        '${wcAPI}products/$productID/variations?per_page=100&$wcCred',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
          responseType: ResponseType.plain,
        ),
      );

      if (errorStatusCodes.contains(response.statusCode)) {
        logger.e(response.data);
        return Left(ServerFailure());
      }

      var result = productVariationFromJson(response.data);
      logger.wtf(result.length);
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
    var response = await dio.get(
      '${wcAPI}products/$productID/variations?per_page=100&$wcCred',
      options: Options(
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        responseType: ResponseType.plain,
      ),
    );
    var result = productVariationFromJson(response.data);
    return result;
  }
}
