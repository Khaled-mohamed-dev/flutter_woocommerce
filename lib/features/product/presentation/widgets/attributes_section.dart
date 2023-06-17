import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/widgets/base_text.dart';
import 'package:flutter_woocommerce/core/widgets/message_alert.dart';
import 'package:flutter_woocommerce/features/product/presentation/bloc/bloc.dart';
import '../../../../core/colors.dart';
import '../../../../core/ui_helpers.dart';
import '../../data/models/product.dart';
import '../../data/models/product_variation.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AttributesSection extends StatefulWidget {
  const AttributesSection(
      {super.key,
      required this.attributes,
      required this.combinations,
      this.variations,
      this.product,
      this.controller,
      this.selectedCombination});

  final Map attributes;
  final Map<String, dynamic> combinations;
  final List<ProductVariation>? variations;
  final Product? product;
  final ScrollController? controller;
  final List<String>? selectedCombination;
  @override
  State<AttributesSection> createState() => _AttributesSectionState();
}

class _AttributesSectionState extends State<AttributesSection> {
  // ------------------------------------------ // ------------------------------------------ //
  // This block of code adds the functionality of displaying to the user the available variations
  // also can be described as the combination of attributes
  late List<String> selectedCombination =
      widget.selectedCombination ?? List.filled(widget.attributes.length, '');

  bool isOptionSelected(String attribute) {
    return selectedCombination.contains(attribute);
  }

  bool isAvailableCombination(String option, int index) {
    if (selectedCombination.every((element) => element == '') &&
        widget.attributes.length > 1) {
      return true;
    }

    var myList = List<String>.from(selectedCombination);
    myList[index] = option;

    if (widget.combinations.keys.any(
      (element) {
        return element
            .replaceAll(' ', '')
            .replaceAll('[', '')
            .replaceAll(']', '')
            .split(',')
            .containsAll((myList..remove(''))
                .map((e) => e.replaceAll(' ', ''))
                .toList());
      },
    )) {
      if (widget.combinations[myList.toString()] != null &&
          (widget.combinations[myList.toString()] as ProductVariation)
                  .stockStatus ==
              'outofstock') {
        return false;
      }
      return true;
    }

    return false;
  }
  // ------------------------------------------ // ------------------------------------------ //

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: kcSecondaryColor),
        verticalSpaceTiny,
        if (selectedCombination.any((element) => element == ''))
          MessageAlert(message: localization.select_variation_display_price),
        verticalSpaceSmall,
        for (var i = 0; i < widget.attributes.length; i++)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BaseText(
                widget.attributes.keys.toList()[i],
                style: Theme.of(context).textTheme.headlineSmall!,
              ),
              verticalSpaceTiny,
              Wrap(
                children: (widget.attributes.values.toList()[i] as List).map(
                  (option) {
                    return GestureDetector(
                      onTap: () {
                        setState(
                          () {
                            if (isOptionSelected(option)) {
                              selectedCombination[i] = '';
                            } else {
                              if (!isAvailableCombination(option, i)) {
                                selectedCombination =
                                    List.filled(widget.attributes.length, '');
                              } else {
                                selectedCombination[i] = option;
                              }
                              if (selectedCombination.length > 1) {
                                selectedCombination[i] = option;
                              }
                            }
                            if (!selectedCombination
                                .any((element) => element == '')) {
                              if (widget.controller != null) {
                                // widget.controller!.jumpTo(widget
                                //     .controller!.position.minScrollExtent);
                              }
                            }
                            BlocProvider.of<ProductsBloc>(context).add(
                              SelectCombination(
                                selectedCombination,
                                product: widget.product,
                                variations: widget.variations,
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        margin: const EdgeInsetsDirectional.only(
                            end: 6.0, bottom: 6.0),
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: kcSecondaryColor, width: 1),
                            borderRadius: BorderRadius.circular(5),
                            color: isOptionSelected(option)
                                ? kcPrimaryColor
                                : null),
                        child: IntrinsicWidth(
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: BaseText(
                                  option,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: isOptionSelected(option)
                                            ? kcButtonIconColor
                                            : null,
                                        fontWeight: isOptionSelected(option)
                                            ? FontWeight.bold
                                            : null,
                                      ),
                                ),
                              ),
                              if (!isAvailableCombination(option, i) &&
                                  !isOptionSelected(option))
                                Container(color: kcPrimaryColor, height: 2),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
              verticalSpaceTiny
            ],
          ),
      ],
    );
  }
}

extension IterableExtensions<E> on Iterable<E> {
  bool containsAll(Iterable<E> elements) {
    for (final e in elements) {
      if (!contains(e)) return false;
    }

    return true;
  }
}
