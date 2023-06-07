import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/core/widgets/base_button.dart';
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
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      IconlyLight.search,
                      color: kcPrimaryColor,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () async {
                        await showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
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
                          return Icon(
                            context.watch<SearchBloc>().state.enableFilters
                                ? IconlyBold.filter
                                : IconlyLight.filter,
                            color: kcIconColorSelected,
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
                    hintStyle: Theme.of(context).textTheme.titleSmall,
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
                                  Text(
                                    localization.no_results,
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            );
                    case SearchStatus.failure:
                      return const Expanded(
                          child: Text('something went wrong'));
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
                                child: Icon(
                                  IconlyBold.search,
                                ),
                              ),
                            ),
                            verticalSpaceRegular,
                            Text(
                              localization.search,
                              style: Theme.of(context).textTheme.bodyLarge,
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
          height: screenHeightPercentage(context, percentage: 0.7),
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                var height = constraints.maxHeight;
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: height * .1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              BlocProvider.of<SearchBloc>(context)
                                  .add(ClearFilters());
                            },
                            child: Text(localization.clear),
                          ),
                          Text(localization.filters),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(IconlyBold.close_square),
                          )
                        ],
                      ),
                    ),
                    const Divider(),
                    verticalSpaceSmall,
                    SizedBox(
                      height: height * .2,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
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
                    ),
                    verticalSpaceRegular,
                    SizedBox(
                      height: height * .2,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
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
                    ),
                    PricingSection(height: height),
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

    var state = BlocProvider.of<SearchBloc>(context).state;
    var params = state.searchParmas;
    RangeValues currentRangeValues = RangeValues(
        double.parse(params.minPrice ?? '400'),
        double.parse(params.maxPrice ?? '700'));

    var firstRangePoint = currentRangeValues.start.round().toString();
    var secondRangePoint = currentRangeValues.end.round().toString();
    return SizedBox(
      height: height * .25,
      width: double.infinity,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(localization.pricing,
                  style: Theme.of(context).textTheme.headlineSmall),
              Text('\$$firstRangePoint-\$$secondRangePoint',
                  style: Theme.of(context).textTheme.headlineSmall),
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
      ),
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
                  child: Text(
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
        });
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
                    child: Text(
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
