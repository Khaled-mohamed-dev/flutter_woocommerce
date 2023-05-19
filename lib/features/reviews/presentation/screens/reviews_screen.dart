import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/features/product/data/models/product.dart';
import 'package:flutter_woocommerce/features/reviews/data/models/review.dart';
import 'package:flutter_woocommerce/features/reviews/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/locator.dart';
import 'package:iconly/iconly.dart';
import 'package:timeago/timeago.dart' as timeago;

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({Key? key, required this.product}) : super(key: key);
  final Product product;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) =>
            locator<ReviewsBloc>()..add(LoadReviews(product.id)),
        child: BlocBuilder<ReviewsBloc, ReviewsState>(
          builder: (context, state) {
            switch (state.status) {
              case ReviewsStatus.initial:
                return Center(
                  child: CircularProgressIndicator(color: kcPrimaryColor),
                );
              case ReviewsStatus.success:
                return ListView.builder(
                  itemCount: state.reviews.length,
                  itemBuilder: (context, index) {
                    var review = state.reviews[index];
                    return ReviewListTile(review: review);
                  },
                );
              case ReviewsStatus.failure:
                return Text(
                  'SOME THING WENT WRONG ',
                  style: Theme.of(context).textTheme.displayMedium,
                );
            }
          },
        ),
      ),
    );
  }
}

class ReviewListTile extends StatelessWidget {
  const ReviewListTile({
    super.key,
    required this.review,
  });

  final Review review;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        print('object');
      },
      isThreeLine: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            review.reviewer,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: kcPrimaryColor, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              child: Row(
                children: [
                  Icon(
                    IconlyBold.star,
                    color: kcPrimaryColor,
                  ),
                  horizontalSpaceTiny,
                  Text(
                    review.rating.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                ],
              ),
            ),
          )
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pText(review.review),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          verticalSpaceTiny,
          Text(
            timeago.format(review.dateCreated!),
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}

String pText(String p) {
  String result = '';
  RegExp regExp = RegExp(r'(?<=\>)(.*?)(?=\<)');
  var matches = regExp.allMatches(p);
  for (var match in matches) {
    result += match.group(0)!;
  }
  return result;
}
