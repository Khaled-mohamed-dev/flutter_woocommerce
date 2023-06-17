import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/widgets/base_text.dart';
import 'package:flutter_woocommerce/core/widgets/responsive_icon.dart';
import 'package:flutter_woocommerce/features/authentication/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/features/authentication/presentation/screens/sign_in_screen.dart';
import 'package:flutter_woocommerce/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:flutter_woocommerce/features/settings/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/features/settings/presentation/screens/contact_us_screen.dart';
import 'package:flutter_woocommerce/features/settings/presentation/screens/refund_policy_screen.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: BaseText(
          localization.profile,
          style: Theme.of(context).textTheme.bodySmall!,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(color: kcSecondaryColor),
            ListTileTheme(
              iconColor: kcPrimaryColor,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const FavoritesScreen(),
                        ),
                      );
                    },
                    leading: const ResponsiveIcon(IconlyLight.heart),
                    title: BaseText(
                      localization.wish_slist,
                      style: Theme.of(context).textTheme.bodySmall!,
                    ),
                    trailing: const ResponsiveIcon(Icons.arrow_forward_ios),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RefundPolicyScreen(),
                        ),
                      );
                    },
                    leading: const ResponsiveIcon(Icons.policy_outlined),
                    title: BaseText(
                      localization.refund_policy,
                      style: Theme.of(context).textTheme.bodySmall!,
                    ),
                    trailing: const ResponsiveIcon(Icons.arrow_forward_ios),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ContactUsScreen(),
                        ),
                      );
                    },
                    leading: const ResponsiveIcon(IconlyLight.call),
                    title: BaseText(
                      localization.contact_us,
                      style: Theme.of(context).textTheme.bodySmall!,
                    ),
                    trailing: const ResponsiveIcon(Icons.arrow_forward_ios),
                  ),
                  ListTile(
                    onTap: () {
                      context.read<SettingsBloc>().add(ThemeChanged());
                    },
                    leading:
                        const ResponsiveIcon(Icons.remove_red_eye_outlined),
                    title: BaseText(
                      localization.dark_mode,
                      style: Theme.of(context).textTheme.bodySmall!,
                    ),
                    trailing: CupertinoSwitch(
                      value: !isLightTheme,
                      activeColor: kcPrimaryColor,
                      thumbColor: kcButtonIconColor,
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(ThemeChanged());
                      },
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      context.read<AuthBloc>().add(LoggedOut());
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SigninScreen(),
                        ),
                      );
                    },
                    leading: const ResponsiveIcon(
                      IconlyLight.logout,
                      color: Colors.red,
                    ),
                    title: BaseText(
                      localization.logout,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.red,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
