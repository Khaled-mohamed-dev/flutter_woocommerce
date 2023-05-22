import 'package:equatable/equatable.dart';
import 'package:flutter_woocommerce/features/checkout/data/models/country_data.dart';
import 'package:flutter_woocommerce/features/checkout/data/models/shipping_zone.dart';
import 'package:flutter_woocommerce/features/checkout/data/models/shipping_zone_location.dart';

import '../../data/models/shipping_method.dart';

enum CheckoutStatus { initial, success, failure }

class CheckoutState extends Equatable {
  final CheckoutStatus status;

  final String shippingAddress;
  final Map<ShippingZone, List<ShippingZoneLocation>>? shippingZones;

  final List<CountryData> countries;
  final CountryData? selectedCountry;
  final State? selectedState;

  final bool isFetchingShippingMethods;
  final bool noShippingMethods;
  final List<ShippingMethod>? shippingMethods;
  final ShippingMethod? selectedShippingMethod;

  const CheckoutState({
    this.status = CheckoutStatus.initial,
    this.shippingAddress = '',
    this.countries = const [],
    this.isFetchingShippingMethods = false,
    this.noShippingMethods = false,
    this.shippingMethods,
    this.selectedCountry,
    this.selectedState,
    this.shippingZones,
    this.selectedShippingMethod,
  });

  CheckoutState copyWith({
    CheckoutStatus? status,
    String? shippingAddress,
    Map<ShippingZone, List<ShippingZoneLocation>>? shippingZones,
    bool? isFetchingShippingMethods,
    List<ShippingMethod>? shippingMethods,
    List<CountryData>? countries,
    bool? noShippingMethods,
    CountryData? selectedCountry,
    State? selectedState,
    ShippingMethod? selectedShippingMethod,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      shippingMethods: shippingMethods ?? this.shippingMethods,
      isFetchingShippingMethods:
          isFetchingShippingMethods ?? this.isFetchingShippingMethods,
      noShippingMethods: noShippingMethods ?? this.noShippingMethods,
      countries: countries ?? this.countries,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedState: selectedState ?? this.selectedState,
      shippingZones: shippingZones ?? this.shippingZones,
      selectedShippingMethod: selectedShippingMethod ?? this.selectedShippingMethod,
    );
  }

  @override
  List<Object?> get props => [
        status,
        countries,
        shippingAddress,
        noShippingMethods,
        shippingMethods,
        isFetchingShippingMethods,
        selectedState,
        selectedCountry,
        shippingZones,
        selectedShippingMethod,
      ];
}
