import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_woocommerce/features/reviews/data/models/review.dart';

import '../../../../core/consts.dart';
import '../../../../core/error/failures.dart';
import '../../../../main.dart';
import 'package:http/http.dart' as http;

abstract class ReviewsRepository {
  Future<Either<Failure, Unit>> leaveReview(Review review);
  Future<Either<Failure, List<Review>>> fetchProductReviews(
      int productID, int page);

  // TODO Find a way to filter reviews by rating
  // Future<Either<Failure, List<Review>>> fetchProductReviewsByRating(
  //     {required int productID, required int rating});
}

class ReviewsRepositoryImpl implements ReviewsRepository {
  final http.Client client;

  ReviewsRepositoryImpl({required this.client});


  @override
  Future<Either<Failure, List<Review>>> fetchProductReviews(
      int productID, int page) async {
    try {
      var response = await client.get(
        Uri.parse(
            '${wcAPI}products/reviews?product=$productID&page=$page&$wcCred'),
      );

      if (errorStatusCodes.contains(response.statusCode)) {
        logger.e(response.body);
        return Left(ServerFailure());
      }

      var reviews = reviewFromJson(response.body);
      logger.wtf(response.body);
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
      var response = await client.post(
        Uri.parse('${wcAPI}products/reviews?$wcCred'),
        body: json.encode(review.toJson()),
        headers: {"content-type": "application/json"},
      );

      if (errorStatusCodes.contains(response.statusCode)) {
        logger.e(response.body);
        return Left(ServerFailure());
      }

      logger.wtf(response.body);
      return const Right(unit);
    } catch (e) {
      logger.e(e);
      return Left(ServerFailure());
    }
  }
}
