import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/features/authentication/data/models/user.dart';
import 'package:flutter_woocommerce/features/authentication/data/repositories/auth_repository.dart';
import 'package:flutter_woocommerce/features/authentication/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/features/authentication/presentation/screens/sign_in_screen.dart';
import 'package:flutter_woocommerce/features/settings/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/features/settings/presentation/screens/address_screen.dart';
import 'package:flutter_woocommerce/locator.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    var auth = locator<AuthRepository>();
    bool isLoggedIn = auth.isLoggedIn();
    User user;
    if (isLoggedIn) {
      user = auth.getSignedInUser()!;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.profile),
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
                    onTap: () {},
                    leading: const Icon(IconlyLight.profile),
                    title: Text(
                      localization.edit_profile,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AddressScreen(),
                        ),
                      );
                    },
                    leading: const Icon(IconlyLight.location),
                    title: Text(
                      localization.address,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(Icons.policy_outlined),
                    title: Text(
                      localization.refund_policy,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(IconlyLight.call),
                    title: Text(
                      localization.contact_us,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                  ListTile(
                    onTap: () {
                      context.read<SettingsBloc>().add(ThemeChanged());
                    },
                    leading: const Icon(Icons.remove_red_eye_outlined),
                    title: Text(
                      localization.dark_mode,
                      style: Theme.of(context).textTheme.bodySmall,
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
                    leading: const Icon(
                      IconlyLight.logout,
                      color: Colors.red,
                    ),
                    title: Text(
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
