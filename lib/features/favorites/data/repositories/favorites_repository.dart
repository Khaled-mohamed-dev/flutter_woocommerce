import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_woocommerce/core/error/failures.dart';
import 'package:flutter_woocommerce/core/services/sharedpref_service.dart';
import 'package:flutter_woocommerce/features/product/data/models/product.dart';

import '../../../../core/consts.dart';
import '../../../../main.dart';

abstract class FavoritesRepository {
  void changeFavoriteStatus(int productID);
  bool isFavorited(int productID);
  Future<Either<Failure, List<Product>>> fetchFavoriteProducts();
}

class FavoritesRepositoryImpl implements FavoritesRepository {
  final SharedPrefService sharedPrefService;
  final Dio dio;

  FavoritesRepositoryImpl({required this.sharedPrefService, required this.dio});

  @override
  void changeFavoriteStatus(int productID) {
    List<String> favoritesIDs = sharedPrefService.favorites;
    if (favoritesIDs.contains(productID.toString())) {
      favoritesIDs.remove('$productID');
    } else {
      favoritesIDs.add('$productID');
    }
    sharedPrefService.favorites = favoritesIDs;
  }

  @override
  Future<Either<Failure, List<Product>>> fetchFavoriteProducts() async {
    var include = sharedPrefService.favorites
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '');
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
  bool isFavorited(int productID) {
    List<String> favoritesIDs = sharedPrefService.favorites;
    return favoritesIDs.contains(productID.toString());
  }
}
