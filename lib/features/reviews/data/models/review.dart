// To parse this JSON data, do
//
//     final Review = ReviewFromJson(jsonString);

import 'dart:convert';

List<Review> reviewFromJson(String str) =>
    List<Review>.from(json.decode(str).map((x) => Review.fromJson(x)));

String reviewToJson(List<Review> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Review {
  final int? id;
  final DateTime? dateCreated;
  final int productId;
  final String? status;
  final String reviewer;
  final String reviewerEmail;
  final String review;
  final int rating;

  Review({
    this.id,
    this.dateCreated,
    required this.productId,
    this.status,
    required this.reviewer,
    required this.reviewerEmail,
    required this.review,
    required this.rating,
  });

  Review copyWith({
    int? id,
    DateTime? dateCreated,
    int? productId,
    String? status,
    String? reviewer,
    String? reviewerEmail,
    String? review,
    int? rating,
  }) =>
      Review(
        id: id ?? this.id,
        dateCreated: dateCreated ?? this.dateCreated,
        productId: productId ?? this.productId,
        status: status ?? this.status,
        reviewer: reviewer ?? this.reviewer,
        reviewerEmail: reviewerEmail ?? this.reviewerEmail,
        review: review ?? this.review,
        rating: rating ?? this.rating,
      );

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        dateCreated: json["date_created"] == null
            ? null
            : DateTime.parse(json["date_created"]),
        productId: json["product_id"],
        status: json["status"],
        reviewer: json["reviewer"],
        reviewerEmail: json["reviewer_email"],
        review: json["review"],
        rating: json["rating"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "reviewer": reviewer,
        "reviewer_email": reviewerEmail,
        "review": review,
        "rating": rating,
        // 'verified': true
      };
}
