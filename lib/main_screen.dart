import 'package:flutter/material.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/widgets/base_text.dart';
import 'package:flutter_woocommerce/core/widgets/responsive_icon.dart';
import 'package:flutter_woocommerce/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_woocommerce/features/settings/presentation/screens/settings_screen.dart';
import 'package:iconly/iconly.dart';
import 'features/cart/presentation/screens/cart_screen.dart';
import 'features/orders/presentation/screens/orders_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTab = 0;
  final List screens = [];
  final PageStorageBucket bucket = PageStorageBucket();

  Widget currentScreen = const HomeScreen();

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    setState(
                      () {
                        currentScreen = const HomeScreen();
                        currentTab = 0;
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ResponsiveIcon(
                          currentTab == 0 ? IconlyBold.home : IconlyLight.home,
                          size: 26,
                          color: currentTab == 0
                              ? kcPrimaryColor
                              : kcBottomNavIconColor,
                        ),
                        BaseText(
                          localization.home,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    setState(
                      () {
                        currentScreen = const CartScreen();
                        currentTab = 1;
                      },
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ResponsiveIcon(
                            currentTab == 1 ? IconlyBold.bag : IconlyLight.bag,
                            color: currentTab == 1
                                ? kcPrimaryColor
                                : kcBottomNavIconColor,
                            size: 26,
                          ),
                          // const Positioned(
                          //     right: -10, top: -10, child: CartNotifier()),
                        ],
                      ),
                      BaseText(
                        localization.cart,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    setState(
                      () {
                        currentTab = 2;
                        currentScreen = const OrdersScreen();
                      },
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ResponsiveIcon(
                        currentTab == 2 ? IconlyBold.buy : IconlyLight.buy,
                        size: 26,
                        color: currentTab == 2
                            ? kcPrimaryColor
                            : kcBottomNavIconColor,
                      ),
                      BaseText(
                        localization.orders,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    setState(
                      () {
                        currentScreen = const SettingsScreen();
                        currentTab = 3;
                      },
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ResponsiveIcon(
                        currentTab == 3
                            ? IconlyBold.profile
                            : IconlyLight.profile,
                        size: 26,
                        color: currentTab == 3
                            ? kcPrimaryColor
                            : kcBottomNavIconColor,
                      ),
                      BaseText(
                        localization.profile,
                        alignment: TextAlign.center,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
