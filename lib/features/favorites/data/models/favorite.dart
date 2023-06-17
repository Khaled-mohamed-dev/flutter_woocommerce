import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'favorite.g.dart';

@HiveType(typeId: 2)
class Favorite extends Equatable {
  @HiveField(0)
  final int productID;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  final String image;

  const Favorite({
    required this.productID,
    required this.productName,
    required this.image,
  });

  Favorite copyWith({
    int? productID,
    int? variationID,
    String? variationTitle,
    int? quantity,
    String? image,
    String? productName,
    String? productPrice,
  }) =>
      Favorite(
        productID: productID ?? this.productID,
        image: image ?? this.image,
        productName: productName ?? this.productName,
      );

  @override
  List<Object?> get props => [productID];
}
