import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/core/widgets/base_button.dart';
import 'package:flutter_woocommerce/core/widgets/base_text.dart';
import 'package:flutter_woocommerce/core/widgets/no_connection.dart';
import 'package:flutter_woocommerce/core/widgets/responsive_icon.dart';
import 'package:flutter_woocommerce/features/home/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/features/product/presentation/widgets/products_grid.dart';
import 'package:flutter_woocommerce/features/search/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/locator.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.search,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: BlocProvider(
        lazy: false,
        create: (context) => locator<SearchBloc>(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Builder(builder: (context) {
                return TextField(
                  onSubmitted: (value) => BlocProvider.of<SearchBloc>(context)
                    ..add(StartSearch(value)),
                  cursorColor: kcPrimaryColor,
                  onChanged: (value) {
                    BlocProvider.of<SearchBloc>(context).add(
                      SetFilters(
                        BlocProvider.of<SearchBloc>(context)
                            .state
                            .searchParmas
                            .copyWith(query: value),
                      ),
                    );
                  },
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize:
                          Theme.of(context).textTheme.bodySmall!.fontSize! *
                              (screenWidth(context) / 3.5) /
                              100),
                  decoration: InputDecoration(
                    prefixIcon: ResponsiveIcon(
                      IconlyLight.search,
                      color: kcPrimaryColor,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () async {
                        await showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                          ),
                          backgroundColor: kcButtonIconColor,
                          builder: (_) {
                            return BlocProvider<SearchBloc>.value(
                              value: BlocProvider.of<SearchBloc>(context),
                              child: const FilterBottomSheet(),
                            );
                          },
                        );
                      },
                      icon: Builder(
                        builder: (context) {
                          return ResponsiveIcon(
                            context.watch<SearchBloc>().state.enableFilters
                                ? IconlyBold.filter
                                : IconlyLight.filter,
                            color: kcPrimaryColor,
                          );
                        },
                      ),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    isDense: true,
                    hintStyle: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(
                            fontSize: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .fontSize! *
                                (screenWidth(context) / 3.5) /
                                100),
                    filled: true,
                    fillColor: kcSecondaryColor,
                    hintText: '${localization.search}..',
                  ),
                );
              }),
              verticalSpaceRegular,
              BlocBuilder<SearchBloc, SearchState>(
                buildWhen: (previous, current) =>
                    previous.searchParmas == current.searchParmas,
                builder: (context, state) {
                  switch (state.status) {
                    case SearchStatus.loading:
                      return Expanded(
                        child: Center(
                            child: CircularProgressIndicator(
                                color: kcPrimaryColor)),
                      );
                    case SearchStatus.success:
                      return state.products.isNotEmpty
                          ? Expanded(
                              child: SingleChildScrollView(
                                child: ProductsGrid(products: state.products),
                              ),
                            )
                          : Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/$notFoundImage.png'),
                                  verticalSpaceRegular,
                                  BaseText(
                                    localization.no_results,
                                    alignment: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium!,
                                  ),
                                ],
                              ),
                            );
                    case SearchStatus.failure:
                      return NoConnectionWidget(reload: () {});
                    case SearchStatus.initial:
                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: screenWidthPercentage(context,
                                  percentage: .3),
                              child: const FittedBox(
                                fit: BoxFit.fitWidth,
                                child: ResponsiveIcon(
                                  IconlyBold.search,
                                ),
                              ),
                            ),
                            verticalSpaceRegular,
                            BaseText(
                              localization.search,
                              style: Theme.of(context).textTheme.bodyLarge!,
                            ),
                          ],
                        ),
                      );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Container(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                var height = constraints.maxHeight;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<SearchBloc>(context)
                                .add(ClearFilters());
                          },
                          child: BaseText(
                            localization.clear,
                            style: Theme.of(context).textTheme.bodySmall!,
                          ),
                        ),
                        BaseText(
                          localization.filters,
                          style: Theme.of(context).textTheme.bodySmall!,
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const ResponsiveIcon(IconlyBold.close_square),
                        )
                      ],
                    ),
                    const Divider(),
                    verticalSpaceSmall,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BaseText(
                          localization.category,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        verticalSpaceTiny,
                        SizedBox(height: height * .1, child: CategoriesList())
                      ],
                    ),
                    verticalSpaceRegular,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BaseText(
                          localization.sort_by,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        verticalSpaceTiny,
                        SizedBox(
                          height: height * .1,
                          child: OrderbyOptionsList(),
                        )
                      ],
                    ),
                    verticalSpaceRegular,
                    PricingSection(height: height),
                    verticalSpaceRegular,
                    BaseButton(
                      title: localization.apply_filters,
                      callback: () {
                        (BlocProvider.of<SearchBloc>(context)
                              ..add(ApplyFilters()))
                            .add(StartSearch(state.searchParmas.query));
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class PricingSection extends StatelessWidget {
  const PricingSection({
    super.key,
    required this.height,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    var state = context.watch<SearchBloc>().state;
    var params = state.searchParmas;
    RangeValues currentRangeValues = RangeValues(
        double.parse(params.minPrice ?? '400'),
        double.parse(params.maxPrice ?? '700'));

    var firstRangePoint = currentRangeValues.start.round().toString();
    var secondRangePoint = currentRangeValues.end.round().toString();
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BaseText(localization.pricing,
                style: Theme.of(context).textTheme.headlineSmall!),
            BaseText('\$$firstRangePoint-\$$secondRangePoint',
                style: Theme.of(context).textTheme.headlineSmall!),
          ],
        ),
        verticalSpaceRegular,
        RangeSlider(
          values: currentRangeValues,
          activeColor: kcPrimaryColor,
          max: 1000,
          divisions: 20,
          labels: RangeLabels(
            currentRangeValues.start.round().toString(),
            currentRangeValues.end.round().toString(),
          ),
          onChanged: (value) {
            currentRangeValues = value;
            BlocProvider.of<SearchBloc>(context).add(
              SetFilters(
                state.searchParmas.copyWith(
                  minPrice: currentRangeValues.start.round().toString(),
                  maxPrice: currentRangeValues.end.round().toString(),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

class CategoriesList extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    var state = BlocProvider.of<SearchBloc>(context).state;
    String selectedCategory = state.searchParmas.categoryID ?? '';
    var categories = BlocProvider.of<HomeBloc>(context).state.categories;
    return ListView.builder(
      itemCount: categories.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        var category = categories[index];
        bool isSelected =
            selectedCategory == category.id.toString() ? true : false;
        return GestureDetector(
          onTap: () {
            BlocProvider.of<SearchBloc>(context).add(SetFilters(
              state.searchParmas.copyWith(categoryID: category.id.toString()),
            ));
          },
          child: Container(
            margin: const EdgeInsetsDirectional.only(end: 10),
            decoration: BoxDecoration(
              color: isSelected ? kcPrimaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: isSelected ? kcPrimaryColor : kcSecondaryColor,
                width: 2,
              ),
            ),
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
                child: BaseText(
                  category.name,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: isSelected ? kcButtonIconColor : null,
                        fontWeight: isSelected ? FontWeight.bold : null,
                      ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class OrderbyOptionsList extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  OrderbyOptionsList({super.key});
  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    var langTypes = {
      'Popular': localization.popular,
      'Most Recent': localization.most_recent,
      'rating': localization.rating
    };

    var state = BlocProvider.of<SearchBloc>(context).state;
    String selected = state.searchParmas.orderBy ?? '';
    return ListView(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      children: ['Popular', 'Most Recent', 'rating']
          .map(
            (e) => GestureDetector(
              onTap: () {
                BlocProvider.of<SearchBloc>(context).add(
                  SetFilters(
                    state.searchParmas.copyWith(orderBy: e),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsetsDirectional.only(end: 10),
                decoration: BoxDecoration(
                  color: selected == e ? kcPrimaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                      color: selected == e ? kcPrimaryColor : kcSecondaryColor,
                      width: 2),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 6),
                    child: BaseText(
                      langTypes[e]!,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: selected == e ? kcButtonIconColor : null,
                            fontWeight: selected == e ? FontWeight.bold : null,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
