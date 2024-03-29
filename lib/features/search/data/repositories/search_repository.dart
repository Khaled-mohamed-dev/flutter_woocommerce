import 'package:dartz/dartz.dart';
import 'package:flutter_woocommerce/core/error/failures.dart';
import 'package:flutter_woocommerce/features/product/data/models/product.dart';
import 'package:flutter_woocommerce/features/search/data/models/search_params.dart';

import '../../../../core/consts.dart';
import '../../../../main.dart';
import 'package:http/http.dart' as http;

abstract class SearchRepository {
  Future<Either<Failure, List<Product>>> searchAndFilterProducts({
    required SearchParmas searchParmas,
    required int page,
  });
}

class SearchRepositoryImpl implements SearchRepository {
  final http.Client client;

  SearchRepositoryImpl({required this.client});

  @override
  Future<Either<Failure, List<Product>>> searchAndFilterProducts({
    required SearchParmas searchParmas,
    required int page,
  }) async {
    var orderFilter = searchParmas.orderBy == null
        ? ''
        : "&orderby=${orderByOption(searchParmas.orderBy!)}";
    var minPriceFilter = searchParmas.minPrice == null
        ? ''
        : "&min_price=${searchParmas.minPrice}";
    var maxPriceFilter = searchParmas.maxPrice == null
        ? ''
        : "&max_price=${searchParmas.maxPrice}";
    var categoryIdFilter = searchParmas.categoryID == null
        ? ''
        : "&category=${searchParmas.categoryID}";
    try {
      var response = await client.get(
        Uri.parse(
            '${wcAPI}products?status=publish&search=${searchParmas.query}&page=$page&${orderFilter + minPriceFilter + maxPriceFilter + categoryIdFilter}&$wcCred'),
      );

      if (errorStatusCodes.contains(response.statusCode)) {
        logger.e(response.body);
        return Left(ServerFailure());
      }

      var result = productFromJson(response.body);
      logger.d(result);
      return Right(result);
    } catch (e) {
      logger.e(e);
      return Left(ServerFailure());
    }
  }
}

String orderByOption(String option) {
  if (option == 'Popular') {
    return 'popularity';
  } else if (option == 'Most Recent') {
    return 'date';
  } else if (option == 'Rating') {
    return 'rating';
  }
  return '';
}
