import 'package:equatable/equatable.dart';
import 'package:flutter_woocommerce/features/checkout/data/models/country_data.dart';
import 'package:flutter_woocommerce/features/checkout/data/models/shipping_method.dart';

abstract class CheckoutEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadCheckout extends CheckoutEvent {}

class FetchShippingZones extends CheckoutEvent {}

class ChangeAddress extends CheckoutEvent {
  final String address;

  ChangeAddress(this.address);
}

class SelectCountry extends CheckoutEvent {
  final CountryData country;

  SelectCountry(this.country);
}

class SelectState extends CheckoutEvent {
  final State state;

  SelectState(this.state);
}

class SelectShippingMethod extends CheckoutEvent {
  final ShippingMethod method;

  SelectShippingMethod(this.method);
}
