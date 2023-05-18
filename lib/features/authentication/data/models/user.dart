// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  User({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.username,
    this.billing,
    this.shipping,
  });

  final int? id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? username;
  final Ing? billing;
  final Ing? shipping;

  User copyWith({
    int? id,
    String? email,
    String? firstName,
    String? lastName,
    String? username,
    Ing? billing,
    Ing? shipping,
  }) =>
      User(
        id: id ?? this.id,
        email: email ?? this.email,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        username: username ?? this.username,
        billing: billing ?? this.billing,
        shipping: shipping ?? this.shipping,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        username: json["username"],
        billing: json["billing"] == null ? null : Ing.fromJson(json["billing"]),
        shipping:
            json["shipping"] == null ? null : Ing.fromJson(json["shipping"]),
      );

  Map<String, dynamic> toJson() => {
        "id" : id,
        "email": email,
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
        "billing": billing?.toJson(),
        "shipping": shipping?.toJson(),
      };
}

class Ing {
  Ing({
    this.firstName,
    this.lastName,
    this.company,
    this.address1,
    this.address2,
    this.city,
    this.state,
    this.postcode,
    this.country,
    this.email,
    this.phone,
  });

  final String? firstName;
  final String? lastName;
  final String? company;
  final String? address1;
  final String? address2;
  final String? city;
  final String? state;
  final String? postcode;
  final String? country;
  final String? email;
  final String? phone;

  Ing copyWith({
    String? firstName,
    String? lastName,
    String? company,
    String? address1,
    String? address2,
    String? city,
    String? state,
    String? postcode,
    String? country,
    String? email,
    String? phone,
  }) =>
      Ing(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        company: company ?? this.company,
        address1: address1 ?? this.address1,
        address2: address2 ?? this.address2,
        city: city ?? this.city,
        state: state ?? this.state,
        postcode: postcode ?? this.postcode,
        country: country ?? this.country,
        email: email ?? this.email,
        phone: phone ?? this.phone,
      );

  factory Ing.fromJson(Map<String, dynamic> json) => Ing(
        firstName: json["first_name"],
        lastName: json["last_name"],
        company: json["company"],
        address1: json["address_1"],
        address2: json["address_2"],
        city: json["city"],
        state: json["state"],
        postcode: json["postcode"],
        country: json["country"],
        email: json["email"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "company": company,
        "address_1": address1,
        "address_2": address2,
        "city": city,
        "state": state,
        "postcode": postcode,
        "country": country,
        "email": email,
        "phone": phone,
      };
}
