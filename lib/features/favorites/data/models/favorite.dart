import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'favorite.g.dart';

@HiveType(typeId: 2)
class Favorite extends Equatable {
  @HiveField(0)
  int productID;

  @HiveField(1)
  String productName;

  @HiveField(2)
  String image;

  Favorite({
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
