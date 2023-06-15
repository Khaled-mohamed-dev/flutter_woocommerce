import 'package:flutter_woocommerce/features/favorites/data/models/favorite.dart';
import 'package:hive/hive.dart';

abstract class FavoritesRepository {
  void changeFavoriteStatus(Favorite product);
  bool isFavorited(int productID);
  List<Favorite> getFavoriteProducts();
}

class FavoritesRepositoryImpl implements FavoritesRepository {
  final Box<Favorite> favoritesBox;

  FavoritesRepositoryImpl({required this.favoritesBox});

  @override
  void changeFavoriteStatus(Favorite product) {
    int productID = product.productID;
    if (favoritesBox.values.any((element) => element.productID == productID)) {
      favoritesBox.delete(productID.toString());
    } else {
      favoritesBox.put(productID.toString(), product);
    }
  }

  @override
  bool isFavorited(int productID) {
    return favoritesBox.values.any((element) => element.productID == productID);
  }

  @override
  List<Favorite> getFavoriteProducts() {
    return favoritesBox.values.toList();
  }
}
