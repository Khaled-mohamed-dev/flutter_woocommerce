import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_woocommerce/features/reviews/data/models/review.dart';

import '../../../../core/consts.dart';
import '../../../../core/error/failures.dart';
import '../../../../main.dart';

abstract class ReviewsRepository {
  Future<Either<Failure, Unit>> leaveReview(Review review);
  Future<Either<Failure, List<Review>>> fetchProductReviews(
      int productID, int page);

  // TODO Find a way to filter reviews by rating
  // Future<Either<Failure, List<Review>>> fetchProductReviewsByRating(
  //     {required int productID, required int rating});
}

class ReviewsRepositoryImpl implements ReviewsRepository {
  final Dio dio;

  ReviewsRepositoryImpl({required this.dio});

  var respnseType = ResponseType.plain;

  @override
  Future<Either<Failure, List<Review>>> fetchProductReviews(
      int productID, int page) async {
    try {
      var response = await dio.get(
        '${wcAPI}products/reviews?product=$productID&page=$page&$wcCred',
        options: Options(
          responseType: respnseType,
        ),
      );

      if (errorStatusCodes.contains(response.statusCode)) {
        logger.e(response.data);
        return Left(ServerFailure());
      }

      var reviews = reviewFromJson(response.data);
      logger.wtf(response.data);
      return Right(reviews);
    } catch (e) {
      logger.e('$e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> leaveReview(Review review) async {
    logger.w(review.toJson());
    try {
      var response = await dio.post(
        '${wcAPI}products/reviews?$wcCred',
        data: review.toJson(),
        options: Options(
          responseType: respnseType,
        ),
      );

      if (errorStatusCodes.contains(response.statusCode)) {
        logger.e(response.data);
        return Left(ServerFailure());
      }

      logger.wtf(response);
      return const Right(unit);
    } catch (e) {
      logger.e(e);
      return Left(ServerFailure());
    }
  }
}
