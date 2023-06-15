import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/features/authentication/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/features/cart/data/models/cart_item.dart';
import 'package:flutter_woocommerce/features/cart/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/features/favorites/data/models/favorite.dart';
import 'package:flutter_woocommerce/features/home/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:flutter_woocommerce/features/orders/presentation/bloc/orders_event.dart';
import 'package:flutter_woocommerce/features/settings/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/main_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'core/theme.dart';
import 'features/authentication/presentation/bloc/sign_from/sign_form_bloc.dart';
import 'features/authentication/presentation/screens/sign_up_screen.dart';
import 'locator.dart';

// Localization imports
import 'package:flutter_woocommerce/l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

var logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CartItemAdapter());
  Hive.registerAdapter(FavoriteAdapter());

  await setupLocator();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => locator<SettingsBloc>()..add(LoadTheme())),
        BlocProvider<AuthBloc>(create: (context) => locator<AuthBloc>()),
        BlocProvider<SignFormBloc>(
            create: (context) => locator<SignFormBloc>()),
        BlocProvider(create: (context) => locator<HomeBloc>()..add(LoadHome())),
        // BlocProvider(
        //     lazy: false, create: (context) => locator<FavoritesBloc>()),
        BlocProvider(
            create: (context) => locator<CartBloc>()..add(LoadCartItems())),
        BlocProvider(
            create: (context) => locator<OrdersBloc>()..add(LoadOrders())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        var theme = state.settingModel.theme == 'light'
            ? ThemeConfig.lightTheme
            : ThemeConfig.darkTheme;
        return MaterialApp(
          builder: (context, child) {
            return ScrollConfiguration(
              behavior: MyBehavior(),
              child: child!,
            );
          },
          title: 'Flutter Woocommerce',
          theme: theme,
          supportedLocales: L10n.all,
          locale: Locale(state.settingModel.language),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          home: BlocListener<AuthBloc, AuthState>(
            bloc: BlocProvider.of<AuthBloc>(context)
              ..add(AuthenticationStarted()),
            listener: (context, state) {
              if (state is Authenticated) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const MainScreen()),
                  ),
                );
              } else if (state is Unauthenticated) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const SignupScreen()),
                  ),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const SignupScreen()),
                  ),
                );
              }
            },
            child: const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        );
      },
    );
  }
}

// to override the default scroll behaviour of a scrollable widget
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}