import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/core/widgets/base_button.dart';
import 'package:flutter_woocommerce/features/reviews/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/locator.dart';
import 'package:iconly/iconly.dart';

class ReviewBottomSheet extends StatefulWidget {
  const ReviewBottomSheet({Key? key, required this.productID})
      : super(key: key);
  final int productID;
  @override
  State<ReviewBottomSheet> createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
  int rate = 0;
  final circularBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
  );
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<ReviewsBloc>(),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Leave a Review',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Divider(color: kcSecondaryColor),
            verticalSpaceSmall,
            Text(
              'How is your order?',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            verticalSpaceTiny,
            Text(
              'Please give your rating & also your review...',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            verticalSpaceSmall,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 1; i <= 5; i++)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        rate = i;
                      });
                    },
                    icon: Icon(
                      rate >= i ? IconlyBold.star : IconlyLight.star,
                      size: 30,
                    ),
                  )
              ],
            ),
            verticalSpaceSmall,
            TextField(
              controller: controller,
              keyboardType: TextInputType.multiline,
              style: Theme.of(context).textTheme.titleMedium,
              decoration: InputDecoration(
                hintText: 'Your feedback..',
                hintStyle: Theme.of(context).textTheme.titleMedium,
                focusColor: kcPrimaryColor,
                filled: true,
                fillColor: kcSecondaryColor,
                isDense: true,
                border: circularBorder.copyWith(
                  borderSide: BorderSide(color: kcSecondaryColor),
                ),
                errorBorder: circularBorder.copyWith(
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedBorder: circularBorder.copyWith(
                  borderSide: BorderSide(color: kcPrimaryColor),
                ),
                enabledBorder: circularBorder.copyWith(
                  borderSide: BorderSide(color: kcSecondaryColor),
                ),
              ),
            ),
            verticalSpaceSmall,
            Divider(color: kcSecondaryColor),
            verticalSpaceSmall,
            Row(
              children: [
                Expanded(
                  child: BaseButton(
                    callback: () {
                      Navigator.of(context).pop();
                    },
                    title: 'cancel',
                    iconColor: Colors.grey,
                  ),
                ),
                horizontalSpaceSmall,
                Builder(
                  builder: (context) {
                    return Expanded(
                      child: BaseButton(
                        callback: () {
                          BlocProvider.of<ReviewsBloc>(context).add(LeaveReview(
                              productID: widget.productID,
                              review: controller.text,
                              rating: rate));
                          Navigator.of(context).pop();
                        },
                        title: 'Submit',
                      ),
                    );
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
