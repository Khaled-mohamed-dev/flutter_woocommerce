import 'package:equatable/equatable.dart';
import 'package:flutter_woocommerce/features/checkout/data/models/country_data.dart';

abstract class CheckoutEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadCheckout extends CheckoutEvent {}

class FetchShippingZones extends CheckoutEvent {}

class SelectCountry extends CheckoutEvent {
  final CountryData country;

  SelectCountry(this.country);
}

class SelectState extends CheckoutEvent {
  final State state;

  SelectState(this.state);
}
