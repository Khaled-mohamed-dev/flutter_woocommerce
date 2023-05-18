import 'package:equatable/equatable.dart';
import 'package:flutter_woocommerce/features/category/data/models/category.dart';
import 'package:flutter_woocommerce/features/product/data/models/product.dart';

class HomeData extends Equatable {
  final List<Product> products;
  final List<Category> categories;

  const HomeData({required this.products, required this.categories});

  HomeData copyWith({List<Product>? products, List<Category>? categories}) =>
      HomeData(
        products: products ?? this.products,
        categories: categories ?? this.categories,
      );

  @override
  List<Object?> get props => [products, categories];
}
