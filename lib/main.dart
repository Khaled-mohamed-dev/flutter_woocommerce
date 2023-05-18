import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/features/authentication/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/features/cart/data/models/cart_item.dart';
import 'package:flutter_woocommerce/features/cart/presentation/bloc/bloc.dart';
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

var logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CartItemAdapter());

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






























// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() async {
//     // locator<CheckoutRepository>().fetchShippingZoneLocations(2);

//     // await locator<HomeRepository>().searchProducts('electro');

//     // var result = await locator<AuthRepository>()
//     //     .register(userName: 'admin4', password: '12345678', emailAddress: 'khaled@admin5.com');
//     // logger.wtf('adsa');
//     // var user = locator<SharedPrefService>().user!;

//     // locator<OrdersRepository>().createOrder(
//     //   Order(
//     //     customerId: 3,
//     //     paymentMethod: 'paymentMethod',
//     //     paymentMethodTitle: 'paymentMethodTitle',
//     //     billing: user.billing!,
//     //     shipping: user.shipping!,
//     //     lineItems: [
//     //       LineItem(productId: 13, quantity: 1),
//     //       LineItem(
//     //         productId: 18,
//     //         quantity: 1,
//     //         metaData: [MetaDataa(key: d['key']!, value: d['value']!)],
//     //       ),
//     //     ],
//     //   ),
//     // );

//     // var result = await locator<AuthRepository>().setupAccount(
//     //   user: locator<SharedPrefService>().user!.copyWith(
//     //         billing: locator<SharedPrefService>().user!.billing!.copyWith(
//     //               firstName: 'khaled',
//     //               lastName: 'mohamed',
//     //               country: 'Egypt',
//     //               city: 'Cairo',
//     //               email: locator<SharedPrefService>().user!.email,
//     //             ),
//     //       ),
//     // );

//     // List<ProductVariation> variationsModel = productVariationFromJson(variations.toString());
//     // print(
//     //   variations.any(
//     //     (element) =>
//     //         element['price'] != '' &&
//     //         (element['attributes'] as List<Map>).any(
//     //           (element) => element['option'] == 'small',
//     //         ),
//     //   ),
//     // );

//     // locator<HomeRepository>().fetchProductsByCategory(24);

//     // -----------------------------------------------------------------------------------------------------------------// -----------------------------------------------------------------------------------------------------------------

//     // Map possibleCombinations = {};
//     // Map usefullAttributes = {};
//     // variations.forEach(
//     //   (variation) {
//     //     if (variation['price'] != '') {
//     //       var combination = [];
//     //       (variation['attributes'] as List<Map>).forEach(
//     //         (attribute) {
//     //           combination.add(attribute['option']);
//     //           var attributeKey = attribute['name'];
//     //           if (usefullAttributes[attributeKey] != null) {
//     //             usefullAttributes[attributeKey] =
//     //                 (usefullAttributes[attributeKey] as List)
//     //                   ..add(
//     //                     attribute['option'],
//     //                   );
//     //           } else {
//     //             usefullAttributes[attributeKey] = [attribute['option']];
//     //           }
//     //           usefullAttributes[attributeKey] =
//     //               (usefullAttributes[attributeKey] as List).toSet().toList();
//     //         },
//     //       );
//     //       possibleCombinations[combination.toString()] = variation;
//     //     }
//     //   },
//     // );

//     // print(possibleCombinations.length);

//     // print(usefullAttributes);

//     // print(possibleCombinations[['large', 'black'].toString()]['price']);

//     // -----------------------------------------------------------------------------------------------------------------// -----------------------------------------------------------------------------------------------------------------

//     // locator<ProductsRepository>().fetchProductVariations(31);
//     // locator<CartRepository>().clearCartItems();

//     // locator<HomeRepository>().fetchCategories();

//     // locator<AuthRepository>().logOut();

//     // print(jsonEncode(locator<SharedPrefService>().user) );

//     // These two give the same result
//     // logger.wtf(jsonEncode(user));
//     // logger.wtf(jsonEncode(user.toJson()));

//     setState(() {
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
