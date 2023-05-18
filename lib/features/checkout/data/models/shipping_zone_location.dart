import 'dart:convert';

import 'package:equatable/equatable.dart';

List<ShippingZoneLocation> shippingZoneLocationFromJson(String str) =>
    List<ShippingZoneLocation>.from(
        json.decode(str).map((x) => ShippingZoneLocation.fromJson(x)));

class ShippingZoneLocation extends Equatable {
  final String code;
  final String type;
  final String? name;

  const ShippingZoneLocation(
      {required this.code, required this.type, this.name});

  factory ShippingZoneLocation.fromJson(Map<String, dynamic> json) =>
      ShippingZoneLocation(
        code: json["code"].toString(),
        type: json["type"],
      );

  ShippingZoneLocation copyWith({String? name}) =>
      ShippingZoneLocation(code: code, type: type, name: name ?? this.name);

  @override
  List<Object?> get props => [code];
}
