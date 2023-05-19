import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/error/failures.dart';
import 'package:flutter_woocommerce/core/services/sharedpref_service.dart';
import 'package:flutter_woocommerce/features/reviews/data/models/review.dart';
import 'package:flutter_woocommerce/features/reviews/data/repositories/reviews_repository.dart';
import 'package:flutter_woocommerce/features/reviews/presentation/bloc/bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../main.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ReviewsBloc extends Bloc<ReviewsEvent, ReviewsState> {
  final ReviewsRepository reviewsRepository;
  final SharedPrefService sharedPrefService;

  ReviewsBloc({
    required this.reviewsRepository,
    required this.sharedPrefService,
  }) : super(const ReviewsState(status: ReviewsStatus.initial)) {
    on<LoadReviews>(
      (event, emit) async {
        if (state.status == ReviewsStatus.success) return;
        final Either<Failure, List<Review>> faliureOrResopnse =
            await reviewsRepository.fetchProductReviews(event.productID, 1);
        emit(
          faliureOrResopnse.fold(
            (l) => state.copyWith(status: ReviewsStatus.failure),
            (reviews) {
              return state.copyWith(
                reviews: reviews,
                status: ReviewsStatus.success,
              );
            },
          ),
        );
      },
    );

    on<FetchMoreReviews>(
      (event, emit) async {
        if (state.reviews.length < 10) {
          emit(state.copyWith(hasReachedMax: true));
        }
        if (state.hasReachedMax) return;
        logger.d('fetch more reviews');

        emit(state.copyWith(isLoadingMore: true));

        int nextPage = ((state.reviews.length / 10) + 1).toInt();

        final Either<Failure, List<Review>> faliureOrResopnse =
            await reviewsRepository.fetchProductReviews(
                event.productID, nextPage);

        emit(
          faliureOrResopnse.fold(
            (l) => state.copyWith(),
            (reviews) {
              var hasReachedMax = reviews.length < 10 ? true : false;
              return state.copyWith(
                reviews: state.reviews..addAll(reviews),
                isLoadingMore: false,
                hasReachedMax: hasReachedMax,
              );
            },
          ),
        );
      },
      transformer: throttleDroppable(throttleDuration),
    );

    on<LeaveReview>(
      (event, emit) {
        var user = sharedPrefService.user!;
        reviewsRepository.leaveReview(
          Review(
            productId: event.productID,
            rating: event.rating,
            review: event.review,
            reviewer: user.username!,
            reviewerEmail: user.email!,
          ),
        );
      },
    );
  }
}
