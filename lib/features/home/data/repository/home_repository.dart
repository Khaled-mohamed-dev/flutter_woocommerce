import 'package:dio/dio.dart';
import 'package:flutter_woocommerce/features/category/data/models/category.dart';
import 'package:flutter_woocommerce/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_woocommerce/features/product/data/models/product.dart';

import '../../../../core/consts.dart';
import '../../../../main.dart';
import '../models/home_data.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Category>>> fetchCategories(int page);
  Future<Either<Failure, List<Product>>> fetchProducts(int page);
  Future<Either<Failure, List<Product>>> fetchProductsByCategory(
      int categoryID);

  Future<Either<Failure, List<Category>>> fetchChildCategories(int categoryID);

  Future<Either<Failure, HomeData>> loadHomeData();
}

class HomeRepositoryImpl implements HomeRepository {
  final Dio dio;

  HomeRepositoryImpl({required this.dio});

  var options = Options(
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
    responseType: ResponseType.plain,
  );

  @override
  Future<Either<Failure, List<Category>>> fetchCategories(int page) async {
    try {
      var response = await dio.get(
        '${wcAPI}products/categories?page=$page&$wcCred',
        options: options,
      );

      var result = categoryFromJson(response.data);

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
      var response = await dio.get(
        '${wcAPI}products?status=publish&page=$page&$wcCred',
        options: options,
      );
      var result = productFromJson(response.data);
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

      var response = await dio.get(
        '${wcAPI}products?category=$categoryID&status=publish&$wcCred',
        options: options,
      );
      if (errorStatusCodes.contains(response.statusCode)) {
        logger.e(response.data);
        return Left(ServerFailure());
      }
      var result = productFromJson(response.data);
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
      var response = await dio.get(
        '${wcAPI}products/categories?parent=$categoryID&$wcCred',
        options: options,
      );
      var result = categoryFromJson(response.data);
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
          dio.get(
            '${wcAPI}products?status=publish&$wcCred',
            options: options,
          ),
          dio.get(
            '${wcAPI}products/categories?$wcCred',
            options: options,
          )
        ],
      );
      var productsReponse = results[0];
      var products = productFromJson(productsReponse.data);

      var categoriesResponse = results[1];
      var categories = categoryFromJson(categoriesResponse.data);

      return Right(HomeData(products: products, categories: categories));
    } catch (e) {
      logger.e('$e');
      return Left(ServerFailure());
    }
  }
}
