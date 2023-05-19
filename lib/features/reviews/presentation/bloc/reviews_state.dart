import 'package:equatable/equatable.dart';
import 'package:flutter_woocommerce/features/reviews/data/models/review.dart';

enum ReviewsStatus { initial, success, failure }

class ReviewsState extends Equatable {
  const ReviewsState({
    this.status = ReviewsStatus.initial,
    this.hasReachedMax = false,
    this.reviews = const [],
    this.isLoadingMore = false,
  });

  final ReviewsStatus status;
  final List<Review> reviews;
  final bool isLoadingMore;
  final bool hasReachedMax;

  ReviewsState copyWith({
    ReviewsStatus? status,
    List<Review>? reviews,
    bool? isLoadingMore,
    bool? hasReachedMax,
  }) {
    return ReviewsState(
        status: status ?? this.status,
        reviews: reviews ?? this.reviews,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  @override
  String toString() {
    return '''ReviewsState { status: $status, response: }''';
  }

  @override
  List<Object> get props => [
        status,
        reviews,
        isLoadingMore,
      ];
}
