import 'package:flutter_woocommerce/core/services/sharedpref_service.dart';
import 'package:flutter_woocommerce/features/authentication/data/repositories/auth_repository.dart';
import 'package:flutter_woocommerce/features/authentication/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/features/authentication/presentation/bloc/sign_from/bloc.dart';
import 'package:flutter_woocommerce/features/cart/data/models/cart_item.dart';
import 'package:flutter_woocommerce/features/cart/data/repositories/cart_repository.dart';
import 'package:flutter_woocommerce/features/cart/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/features/category/data/repositories/category_repository.dart';
import 'package:flutter_woocommerce/features/category/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/features/favorites/data/models/favorite.dart';
import 'package:flutter_woocommerce/features/favorites/data/repositories/favorites_repository.dart';
import 'package:flutter_woocommerce/features/home/data/repository/home_repository.dart';
import 'package:flutter_woocommerce/features/home/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/features/orders/data/repositories/orders_repository.dart';
import 'package:flutter_woocommerce/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:flutter_woocommerce/features/product/data/repositories/products_repository.dart';
import 'package:flutter_woocommerce/features/product/presentation/bloc/products_bloc.dart';
import 'package:flutter_woocommerce/features/reviews/data/repositories/reviews_repository.dart';
import 'package:flutter_woocommerce/features/reviews/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/features/search/data/repositories/search_repository.dart';
import 'package:flutter_woocommerce/features/search/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/features/settings/data/repositories/settings_repository.dart';
import 'package:flutter_woocommerce/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

final locator = GetIt.instance;

Future setupLocator() async {
  //Feature - Home

  locator.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      client: locator(),
    ),
  );

  locator.registerFactory<HomeBloc>(
    () => HomeBloc(
      homeRepository: locator(),
    ),
  );

  //Feature - Order

  locator.registerLazySingleton<OrdersRepository>(
    () => OrdersRepositoryImpl(client: locator(), sharedPrefService: locator()),
  );

  locator.registerFactory<OrdersBloc>(
    () => OrdersBloc(ordersRepository: locator()),
  );

  //Feature - Reviews

  locator.registerLazySingleton<ReviewsRepository>(
    () => ReviewsRepositoryImpl(
      client: locator(),
    ),
  );

  locator.registerFactory<ReviewsBloc>(
    () =>
        ReviewsBloc(reviewsRepository: locator(), sharedPrefService: locator()),
  );

  //Feature - Auth

  locator.registerFactory<AuthBloc>(() => AuthBloc(authRepository: locator()));

  locator.registerFactory<SignFormBloc>(
      () => SignFormBloc(authRepository: locator()));

  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      client: locator(),
      sharedPrefService: locator(),
    ),
  );

  //Feature - Search

  locator.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(
      client: locator(),
    ),
  );

  locator.registerFactory<SearchBloc>(
    () => SearchBloc(
      searchRepository: locator(),
    ),
  );

  //Feature - Cart

  Box<CartItem> box = await Hive.openBox('cart');

  locator.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(
      cartBox: box,
      client: locator(),
    ),
  );

  locator.registerFactory<CartBloc>(
    () => CartBloc(cartRepository: locator()),
  );

  //Feature - favorites

  Box<Favorite> favoritesBox = await Hive.openBox('favorites');

  locator.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(
      favoritesBox: favoritesBox,
    ),
  );

  //Feature - Products

  locator.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(
      client: locator(),
    ),
  );

  locator.registerFactory<ProductsBloc>(
    () =>
        ProductsBloc(productsRepository: locator(), cartRepository: locator()),
  );

  //Feature - Category

  locator.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(
      client: locator(),
    ),
  );

  locator.registerFactory<CategoryBloc>(
    () => CategoryBloc(
      categoryRepository: locator(),
    ),
  );

  //Feature - Settings

  locator.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(locator()),
  );

  locator.registerFactory(
    () => SettingsBloc(
      settingsRepository: locator(),
      sharedPrefService: locator(),
    ),
  );

  //Core

  var instance = await SharedPreferences.getInstance();
  locator.registerSingleton<SharedPrefService>(
    SharedPrefService(sharedPreferences: instance),
  );

  //External

  locator.registerSingleton<http.Client>(http.Client());
}
