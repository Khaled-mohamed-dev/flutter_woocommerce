import 'package:equatable/equatable.dart';

abstract class ReviewsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadReviews extends ReviewsEvent {
  final int productID;

  LoadReviews(this.productID);
}

class FetchMoreReviews extends ReviewsEvent {
  final int productID;

  FetchMoreReviews(this.productID);
}

class LeaveReview extends ReviewsEvent {
  final int productID;
  final int rating;
  final String review;
  LeaveReview(
      {required this.productID, required this.rating, required this.review});
}
