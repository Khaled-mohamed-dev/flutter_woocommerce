import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'cart_item.g.dart';

@HiveType(typeId: 1)
class CartItem extends Equatable {
  @HiveField(0)
  int productID;

  @HiveField(1)
  int? variationID;

  @HiveField(6)
  String? variationTitle;

  @HiveField(2)
  int quantity;

  @HiveField(3)
  String productPrice;

  @HiveField(4)
  String productName;

  @HiveField(5)
  String image;

  CartItem({
    required this.productID,
    this.variationID,
    this.variationTitle,
    required this.quantity,
    this.productPrice = '0',
    required this.productName,
    required this.image,
  });

  CartItem copyWith({
    int? productID,
    int? variationID,
    String? variationTitle,
    int? quantity,
    String? image,
    String? productName,
    String? productPrice,
  }) =>
      CartItem(
        productID: productID ?? this.productID,
        variationTitle: variationTitle ?? this.variationTitle,
        variationID: variationID ?? this.variationID,
        quantity: quantity ?? this.quantity,
        image: image ?? this.image,
        productName: productName ?? this.productName,
        productPrice: productPrice ?? this.productPrice,
      );

  @override
  List<Object?> get props => [productID, variationID];
}
