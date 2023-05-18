// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Category> categoryFromJson(String str) =>
    List<Category>.from(json.decode(str).map((x) => Category.fromJson(x)));

class Category {
  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.parent,
    required this.description,
    required this.display,
    required this.image,
    required this.menuOrder,
    required this.count,
  });

  final int id;
  final String name;
  final String slug;
  final int parent;
  final String description;
  final String display;
  final String? image;
  final int menuOrder;
  final int count;

  Category copyWith({
    int? id,
    String? name,
    String? slug,
    int? parent,
    String? description,
    String? display,
    String? image,
    int? menuOrder,
    int? count,
  }) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        slug: slug ?? this.slug,
        parent: parent ?? this.parent,
        description: description ?? this.description,
        display: display ?? this.display,
        image: image ?? this.image,
        menuOrder: menuOrder ?? this.menuOrder,
        count: count ?? this.count,
      );

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        parent: json["parent"],
        description: json["description"],
        display: json["display"],
        image: json["image"] == null ? null : json["image"]['src'] ,
        menuOrder: json["menu_order"],
        count: json["count"],
      );
}

