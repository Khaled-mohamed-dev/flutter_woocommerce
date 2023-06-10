import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/core/widgets/base_button.dart';
import 'package:flutter_woocommerce/features/checkout/presentation/bloc/bloc.dart';

import '../../data/models/country_data.dart' as data;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShippingMethodsScreen extends StatelessWidget {
  const ShippingMethodsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(localization.shipping_methods)),
      body: BlocBuilder<CheckoutBloc, CheckoutState>(
        builder: (context, state) {
          switch (state.status) {
            case CheckoutStatus.initial:
              return Center(
                  child: CircularProgressIndicator(color: kcPrimaryColor));
            case CheckoutStatus.success:
              var countries = state.countries;
              var selectedCountry = state.selectedCountry;
              // var selectedState =
              //     selectedCountry.states.isEmpty  ? null : state.selectedState;
              var selectedState = state.selectedState;
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: AlignmentDirectional.centerStart,
                                  end: AlignmentDirectional.centerEnd,
                                  stops: const [0.015, 0.015],
                                  colors: [kcPrimaryColor, kcSecondaryColor],
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Container(
                                margin:
                                    const EdgeInsetsDirectional.only(start: 4),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    localization.select_city_display_methods,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                ),
                              ),
                            ),
                            verticalSpaceRegular,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  localization.country,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                verticalSpaceRegular,
                                DropdownButtonHideUnderline(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: kcCartItemBackgroundColor,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: DropdownButton<data.CountryData>(
                                        menuMaxHeight: screenHeightPercentage(
                                            context,
                                            percentage: .5),
                                        borderRadius: BorderRadius.circular(15),
                                        dropdownColor: kcSecondaryColor,
                                        alignment: AlignmentDirectional.center,
                                        // isDense: true,
                                        isExpanded: true,
                                        value: selectedCountry,
                                        items: countries
                                            .map(
                                              (e) => DropdownMenuItem<
                                                  data.CountryData>(
                                                value: e,
                                                child: Text(e.name),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          BlocProvider.of<CheckoutBloc>(context)
                                              .add(SelectCountry(value!));
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            verticalSpaceMedium,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  localization.city,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                verticalSpaceRegular,
                                DropdownButtonHideUnderline(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: kcCartItemBackgroundColor,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: DropdownButton<data.State>(
                                        borderRadius: BorderRadius.circular(15),
                                        menuMaxHeight: screenHeightPercentage(
                                            context,
                                            percentage: .5),
                                        dropdownColor: kcSecondaryColor,
                                        alignment: AlignmentDirectional.center,
                                        isExpanded: true,
                                        value: selectedState,
                                        items: selectedCountry?.states
                                            .map(
                                              (e) =>
                                                  DropdownMenuItem<data.State>(
                                                value: e,
                                                child: Text(e.name),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          BlocProvider.of<CheckoutBloc>(context)
                                              .add(SelectState(value!));
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (state.isFetchingShippingMethods)
                              Column(
                                children: [
                                  verticalSpaceMedium,
                                  Center(
                                    child: CircularProgressIndicator(
                                        color: kcPrimaryColor),
                                  ),
                                ],
                              )
                            else
                              state.shippingMethods != null &&
                                      !state.noShippingMethods
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        verticalSpaceRegular,
                                        Divider(color: kcSecondaryColor),
                                        verticalSpaceRegular,
                                        Text(
                                          localization.shipping_methods,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                        verticalSpaceSmall,
                                        ...state.shippingMethods!.map(
                                          (method) => Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: RadioListTile(
                                              value: method,
                                              groupValue:
                                                  state.selectedShippingMethod,
                                              onChanged: (value) {
                                                context
                                                    .read<CheckoutBloc>()
                                                    .add(SelectShippingMethod(
                                                        method));
                                              },
                                              tileColor:
                                                  kcCartItemBackgroundColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .trailing,
                                              title: Row(
                                                children: [
                                                  Text(method.title),
                                                  Text(
                                                      " : ${double.parse(method.cost)} \$"),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  : state.noShippingMethods
                                      ? Column(
                                          children: [
                                            verticalSpaceRegular,
                                            Text(localization
                                                .no_available_shipping_methods),
                                          ],
                                        )
                                      : const SizedBox()
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: BaseButton(
                      title: localization.resume,
                      callback: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              );
            case CheckoutStatus.failure:
              return const Center(child: Text('some thing went wrong'));
          }
        },
      ),
    );
  }
}
