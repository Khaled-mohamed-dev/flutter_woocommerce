import 'package:equatable/equatable.dart';

class SearchParmas extends Equatable {
  final String query;
  final String? orderBy;
  final String? minPrice;
  final String? maxPrice;
  final String? categoryID;

  const SearchParmas(
      {required this.query,
      this.orderBy,
      this.minPrice,
      this.maxPrice,
      this.categoryID});

  SearchParmas copyWith(
          {String? query,
          String? orderBy,
          String? minPrice,
          String? maxPrice,
          String? categoryID}) =>
      SearchParmas(
        query: query ?? this.query,
        orderBy: orderBy ?? this.orderBy,
        minPrice: minPrice ?? this.minPrice,
        maxPrice: maxPrice ?? this.maxPrice,
        categoryID: categoryID ?? this.categoryID,
      );
  @override
  List<Object?> get props => [query, orderBy, minPrice, maxPrice, categoryID];
}
