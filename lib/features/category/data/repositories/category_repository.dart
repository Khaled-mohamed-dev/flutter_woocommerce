import 'package:dartz/dartz.dart';
import 'package:flutter_woocommerce/core/consts.dart';
import 'package:flutter_woocommerce/core/error/failures.dart';

import '../../../../main.dart';
import '../../../product/data/models/product.dart';
import 'package:http/http.dart' as http;

abstract class CategoryRepository {
  Future<Either<Failure, List<Product>>> fetchProductsByCategory(
      int categoryID, int page);
}

class CategoryRepositoryImpl implements CategoryRepository {
  final http.Client client;

  CategoryRepositoryImpl({required this.client});

  @override
  Future<Either<Failure, List<Product>>> fetchProductsByCategory(
      int categoryID, int page) async {
    try {
      final stopwatch = Stopwatch()..start();

      var response = await client.get(
        Uri.parse('${wcAPI}products?category=$categoryID&page=$page&$wcCred'),
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
}
