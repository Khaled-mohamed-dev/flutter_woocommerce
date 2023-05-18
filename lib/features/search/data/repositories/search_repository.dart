import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_woocommerce/core/error/failures.dart';
import 'package:flutter_woocommerce/features/product/data/models/product.dart';
import 'package:flutter_woocommerce/features/search/data/models/search_params.dart';

import '../../../../core/consts.dart';
import '../../../../main.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<Product>>> searchAndFilterProducts({
    required SearchParmas searchParmas,
    required int page,
  });
}

class SearchRepositoryImpl implements SearchRepository {
  final Dio dio;

  SearchRepositoryImpl({required this.dio});

  var options = Options(
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
    responseType: ResponseType.plain,
  );

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
      var response = await dio.get(
        '${wcAPI}products?status=publish&search=${searchParmas.query}&page=$page&${orderFilter + minPriceFilter + maxPriceFilter + categoryIdFilter}&$wcCred',
        options: options,
      );
      var result = productFromJson(response.data);
      logger.d(result);
      return Right(result);
    } on DioError catch (e) {
      logger.e('${e.response}');
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
