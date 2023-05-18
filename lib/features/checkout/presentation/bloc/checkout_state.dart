import 'package:equatable/equatable.dart';
import 'package:flutter_woocommerce/features/checkout/data/models/country_data.dart';
import 'package:flutter_woocommerce/features/checkout/data/models/shipping_zone.dart';
import 'package:flutter_woocommerce/features/checkout/data/models/shipping_zone_location.dart';

import '../../data/models/shipping_method.dart';

class CheckoutState extends Equatable {
  final String shippingAddress;
  final Map<ShippingZone, List<ShippingZoneLocation>>? shippingZones;
  final ShippingMethod? shippingMethod;
  final List<CountryData> countries;
  final CountryData? selectedCountry;
  final State? selectedState;
  final bool isFetchingShippingMethods;
  final bool noShippingMethods;
  final List<ShippingMethod>? shippingMethods;
  const CheckoutState({
    this.shippingAddress = '',
    this.countries = const [],
    this.isFetchingShippingMethods = false,
    this.noShippingMethods = false,
    this.shippingMethods,
    this.selectedCountry,
    this.selectedState,
    this.shippingZones,
    this.shippingMethod,
  });

  CheckoutState copyWith({
    String? shippingAddress,
    Map<ShippingZone, List<ShippingZoneLocation>>? shippingZones,
    bool? isFetchingShippingMethods,
    List<ShippingMethod>? shippingMethods,
    List<CountryData>? countries,
    bool? noShippingMethods,
    CountryData? selectedCountry,
    State? selectedState,
    ShippingMethod? shippingMethod,
  }) {
    return CheckoutState(
      shippingAddress: shippingAddress ?? this.shippingAddress,
      shippingMethods: shippingMethods ?? this.shippingMethods,
      isFetchingShippingMethods:
          isFetchingShippingMethods ?? this.isFetchingShippingMethods,
      noShippingMethods: noShippingMethods ?? this.noShippingMethods,
      countries: countries ?? this.countries,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedState: selectedState ?? this.selectedState,
      shippingZones: shippingZones ?? this.shippingZones,
      shippingMethod: shippingMethod ?? this.shippingMethod,
    );
  }

  @override
  List<Object?> get props => [
        countries,
        shippingAddress,
        noShippingMethods,
        shippingMethods,
        isFetchingShippingMethods,
        selectedState,
        selectedCountry,
        shippingZones,
        shippingMethod,
      ];
}
