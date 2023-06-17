import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/widgets/responsive_icon.dart';
import 'package:flutter_woocommerce/features/product/presentation/bloc/bloc.dart';

import '../../../../core/ui_helpers.dart';

class ImageSection extends StatefulWidget {
  const ImageSection({Key? key, required this.images}) : super(key: key);
  final List<String> images;
  @override
  State<ImageSection> createState() => _ImageSectionState();
}

class _ImageSectionState extends State<ImageSection> {
  var page = 0;

  late List images = [...widget.images];

  final CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsBloc, ProductsState>(
      listenWhen: (previous, current) =>
          previous.variationImage != current.variationImage,
      listener: ((context, state) {
        if (state.variationImage != null) {
          if (images.isEmpty) {
            images.add(state.variationImage!);
          } else {
            if (!widget.images.contains(images[0])) {
              images.removeAt(0);
            }
            if (!images.contains(state.variationImage)) {
              images.insert(0, state.variationImage!);
              carouselController.jumpToPage(0);
            }
          }
        } else {
          if (images.length > widget.images.length) {
            images.removeAt(0);
            if (page > 0) {
              carouselController.jumpToPage(page - 1);
            }
          }
        }
      }),
      child: Container(
        color: kcSecondaryColor,
        width: screenWidth(context),
        height: screenWidth(context),
        constraints: BoxConstraints(
            maxHeight: screenHeightPercentage(context, percentage: .5)),
        child: images.isNotEmpty
            ? Stack(
                alignment: Alignment.center,
                children: [
                  CarouselSlider(
                    carouselController: carouselController,
                    items: images
                        .map(
                          (image) => Padding(
                            padding:
                                const EdgeInsets.all(24.0).copyWith(bottom: 34),
                            child: Image.network(
                              image,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        )
                        .toList(),
                    options: CarouselOptions(
                      aspectRatio: 1,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          page = index;
                        });
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    child: DotsIndicator(
                      length: images.length,
                      page: page,
                    ),
                  )
                ],
              )
            : const ResponsiveIcon(Icons.image),
      ),
    );
  }
}

class DotsIndicator extends StatelessWidget {
  const DotsIndicator({Key? key, required this.length, required this.page})
      : super(key: key);
  final int length;
  final int page;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < length; i++)
            AnimatedContainer(
              margin: const EdgeInsetsDirectional.only(end: 8.0),
              duration: const Duration(milliseconds: 350),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: i == page ? kcPrimaryColor : kcButtonIconColor,
              ),
              width: i == page ? 30 : 10,
              height: 10,
            )
        ],
      ),
    );
  }
}
