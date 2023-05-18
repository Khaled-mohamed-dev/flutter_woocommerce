import 'dart:convert';

List<ShippingMethod> shippingMethodsFromJson(String str) =>
    List<ShippingMethod>.from(
        json.decode(str).map((x) => ShippingMethod.fromJson(x)));

class ShippingMethod {
  final int id;
  final String title;
  final bool enabled;
  final String methodID;
  final String methodDescription;
  final String cost;

  ShippingMethod({
    required this.id,
    required this.title,
    required this.enabled,
    required this.methodID,
    required this.methodDescription,
    required this.cost,
  });

  factory ShippingMethod.fromJson(Map<String, dynamic> json) => ShippingMethod(
        id: json['id'],
        title: json['title'],
        enabled: json['enabled'],
        methodID: json['method_id'],
        methodDescription: json['method_description'],
        cost: json['settings'].containsKey("cost")
            ? json['settings']["cost"]["value"] != ""
                ? json['settings']["cost"]["value"]
                : "0"
            : "0",
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'enabled': enabled,
        'method_id': methodID,
        'method_description': methodDescription,
        'cost': cost,
      };
}
