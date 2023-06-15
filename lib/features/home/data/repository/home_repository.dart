import 'package:flutter_woocommerce/features/category/data/models/category.dart';
import 'package:flutter_woocommerce/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_woocommerce/features/product/data/models/product.dart';

import '../../../../core/consts.dart';
import '../../../../main.dart';
import '../models/home_data.dart';
import 'package:http/http.dart' as http;

abstract class HomeRepository {
  Future<Either<Failure, List<Category>>> fetchCategories(int page);
  Future<Either<Failure, List<Product>>> fetchProducts(int page);
  Future<Either<Failure, List<Product>>> fetchProductsByCategory(
      int categoryID);

  Future<Either<Failure, List<Category>>> fetchChildCategories(int categoryID);

  Future<Either<Failure, HomeData>> loadHomeData();
}

class HomeRepositoryImpl implements HomeRepository {
  final http.Client client;

  HomeRepositoryImpl({required this.client});

  @override
  Future<Either<Failure, List<Category>>> fetchCategories(int page) async {
    try {
      var response = await client.get(
        Uri.parse('${wcAPI}products/categories?page=$page&$wcCred'),
      );

      if (errorStatusCodes.contains(response.statusCode)) {
        logger.e(response.body);
        return Left(ServerFailure());
      }
      var result = categoryFromJson(response.body);
      // THIS IS A SOLUTION TO CHECK IF THE CATEGORY HAS ANY CHILD CATEGORIES BUT USING CHILDCATEGORIES FUNCTION IS BETTER THAT IS THE LAS THING
      // I HAVE CAME TO FIND OUTS
      // var parentCategories = result
      //     .where((element) =>
      //         result
      //             .any((secondElement) => element.id == secondElement.parent) &&
      //         element.parent == 0)
      //     .toList();

      // logger.wtf(parentCategories);

      logger.d(result);
      return Right(result);
    } catch (e) {
      logger.e('$e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Product>>> fetchProducts(int page) async {
    try {
      var response = await client.get(
        Uri.parse('${wcAPI}products?status=publish&page=$page&$wcCred'),
      );
      if (errorStatusCodes.contains(response.statusCode)) {
        logger.e(response.body);
        return Left(ServerFailure());
      }

      var result = productFromJson(response.body);
      logger.d(result);
      return Right(result);
    } catch (e) {
      logger.e('$e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Product>>> fetchProductsByCategory(
      int categoryID) async {
    try {
      final stopwatch = Stopwatch()..start();

      var response = await client.get(
        Uri.parse(
            '${wcAPI}products?category=$categoryID&status=publish&$wcCred'),
      );
      if (errorStatusCodes.contains(response.statusCode)) {
        logger.e(response.body);
        return Left(ServerFailure());
      }
      var result = productFromJson(response.body);
      logger.d(result);
      logger.wtf('function executed in ${stopwatch.elapsed}');

      stopwatch.stop();
      return Right(result);
    } catch (e) {
      logger.e('$e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Category>>> fetchChildCategories(
      int categoryID) async {
    try {
      var response = await client.get(
        Uri.parse('${wcAPI}products/categories?parent=$categoryID&$wcCred'),
      );

      if (errorStatusCodes.contains(response.statusCode)) {
        logger.e(response.body);
        return Left(ServerFailure());
      }

      var result = categoryFromJson(response.body);
      logger.d(result);
      return Right(result);
    } catch (e) {
      logger.e('$e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, HomeData>> loadHomeData() async {
    try {
      var results = await Future.wait(
        [
          client.get(
            Uri.parse('${wcAPI}products?status=publish&$wcCred'),
          ),
          client.get(
            Uri.parse('${wcAPI}products/categories?$wcCred'),
          )
        ],
      );

      if (results
          .any(((result) => errorStatusCodes.contains(result.statusCode)))) {
        logger.e(results[0].body);

        logger.e(results[1].body);
        return Left(ServerFailure());
      }

      var productsReponse = results[0];
      var products = productFromJson(productsReponse.body);

      var categoriesResponse = results[1];
      var categories = categoryFromJson(categoriesResponse.body);

      return Right(HomeData(products: products, categories: categories));
    } catch (e) {
      logger.e('$e');
      return Left(ServerFailure());
    }
  }
}
