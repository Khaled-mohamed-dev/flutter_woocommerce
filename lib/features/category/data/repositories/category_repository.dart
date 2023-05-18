import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_woocommerce/core/consts.dart';
import 'package:flutter_woocommerce/core/error/failures.dart';

import '../../../../main.dart';
import '../../../product/data/models/product.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<Product>>> fetchProductsByCategory(
      int categoryID, int page);
}

class CategoryRepositoryImpl implements CategoryRepository {
  final Dio dio;

  CategoryRepositoryImpl({required this.dio});

  var options = Options(
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
    responseType: ResponseType.plain,
  );

  @override
  Future<Either<Failure, List<Product>>> fetchProductsByCategory(
      int categoryID, int page) async {
    try {
      final stopwatch = Stopwatch()..start();

      var response = await dio.get(
        '${wcAPI}products?category=$categoryID&page=$page&$wcCred',
        options: options,
      );

      var result = productFromJson(response.data);

      logger.d(result);

      logger.wtf('function executed in ${stopwatch.elapsed}');

      stopwatch.stop();
      return Right(result);
    } on DioError catch (e) {
      logger.e('$e');
      return Left(ServerFailure());
    }
  }
}
