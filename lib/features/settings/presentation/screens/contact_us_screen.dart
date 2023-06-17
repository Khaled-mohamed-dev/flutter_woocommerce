import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/core/widgets/base_text.dart';
import 'package:flutter_woocommerce/core/widgets/responsive_icon.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.contact_us),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              ContactUsListTile(
                url: 'url',
                platform: localization.facebook,
                icon: Ionicons.logo_facebook,
              ),
              ContactUsListTile(
                url: 'url',
                platform: localization.whatsApp,
                icon: Ionicons.logo_whatsapp,
              ),
              ContactUsListTile(
                url: 'url',
                platform: localization.website,
                icon: Icons.web_asset,
              ),
              ContactUsListTile(
                url: 'url',
                platform: localization.twitter,
                icon: Ionicons.logo_twitter,
              ),
              ContactUsListTile(
                url: 'url',
                platform: localization.instagram,
                icon: Ionicons.logo_instagram,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactUsListTile extends StatelessWidget {
  const ContactUsListTile({
    super.key,
    required this.url,
    required this.platform,
    required this.icon,
  });
  final String url;
  final String platform;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: ListTile(
        minVerticalPadding: 18,
        onTap: () {
          launchUrl(Uri.parse(url));
        },
        tileColor: kcCartItemBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ResponsiveIcon(
              icon,
              color: kcPrimaryColor,
            ),
            horizontalSpaceMedium,
            BaseText(
              platform,
              style: Theme.of(context).textTheme.bodyMedium!,
            ),
          ],
        ),
      ),
    );
  }
}
