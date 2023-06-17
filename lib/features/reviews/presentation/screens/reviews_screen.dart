import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/core/widgets/base_text.dart';
import 'package:flutter_woocommerce/core/widgets/no_connection.dart';
import 'package:flutter_woocommerce/core/widgets/responsive_icon.dart';
import 'package:flutter_woocommerce/features/product/data/models/product.dart';
import 'package:flutter_woocommerce/features/reviews/data/models/review.dart';
import 'package:flutter_woocommerce/features/reviews/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/locator.dart';
import 'package:iconly/iconly.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({Key? key, required this.product}) : super(key: key);
  final Product product;
  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: BaseText(
          "${product.averageRating} (${product.ratingCount} ${localization.reviews})",
          style: Theme.of(context).textTheme.bodySmall!,
        ),
      ),
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
                return NoConnectionWidget(reload: () {
                  context.read<ReviewsBloc>().add(LoadReviews(product.id));
                });
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
    timeago.setLocaleMessages('ar', timeago.ArMessages());

    return ListTile(
      onTap: () {},
      isThreeLine: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BaseText(
            review.reviewer,
            style: Theme.of(context).textTheme.bodyMedium!,
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
                  ResponsiveIcon(
                    IconlyBold.star,
                    color: kcPrimaryColor,
                  ),
                  horizontalSpaceTiny,
                  BaseText(
                    review.rating.toString(),
                    style: Theme.of(context).textTheme.bodyMedium!,
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
          BaseText(
            pText(review.review),
            style: Theme.of(context).textTheme.titleLarge!,
          ),
          verticalSpaceTiny,
          BaseText(
            timeago.format(review.dateCreated!,
                locale: Localizations.localeOf(context).languageCode),
            style: Theme.of(context).textTheme.titleSmall!,
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
