import 'dart:convert';

import 'package:equatable/equatable.dart';

List<ShippingZone> shippingZoneFromJson(String str) => List<ShippingZone>.from(
    json.decode(str).map((x) => ShippingZone.fromJson(x)));

class ShippingZone extends Equatable {
  final int id;
  final String name;
  final int order;

  const ShippingZone({
    required this.id,
    required this.name,
    required this.order,
  });

  factory ShippingZone.fromJson(Map<String, dynamic> json) => ShippingZone(
        id: json["id"],
        name: json["name"],
        order: json["order"],
      );

  @override
  List<Object?> get props => [id];
}
