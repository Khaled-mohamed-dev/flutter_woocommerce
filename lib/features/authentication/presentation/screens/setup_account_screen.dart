import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/core/widgets/base_button.dart';
import 'package:flutter_woocommerce/core/widgets/base_text.dart';
import 'package:flutter_woocommerce/core/widgets/custome_text_field.dart';
import 'package:flutter_woocommerce/features/authentication/presentation/bloc/sign_from/bloc.dart';
import 'package:flutter_woocommerce/main_screen.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SetupAccountScreen extends StatefulWidget {
  const SetupAccountScreen({Key? key}) : super(key: key);

  @override
  State<SetupAccountScreen> createState() => _SetupAccountScreenState();
}

class _SetupAccountScreenState extends State<SetupAccountScreen> {
  final circularBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
  );

  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.complete_profile),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      hint: localization.full_name,
                      icon: IconlyBold.profile,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localization.required_field;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight(context) * .02),
                    CustomTextField(
                      controller: _addressController,
                      keyboardType: TextInputType.streetAddress,
                      hint: localization.address,
                      icon: IconlyBold.location,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localization.required_field;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight(context) * .02),
                    CustomTextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      hint: localization.phone_number,
                      icon: IconlyBold.call,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localization.required_field;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight(context) * .04),
                  ],
                ),
              ),
            ),
            verticalSpaceSmall,
            Column(
              children: [
                BaseButton(
                  title: localization.resume,
                  callback: () {
                    context.read<SignFormBloc>().add(
                          SetupAccount(
                            fullName: _nameController.text,
                            address: _addressController.text,
                            phoneNumber: _phoneController.text,
                          ),
                        );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainScreen(),
                      ),
                    );
                  },
                ),
                verticalSpaceTiny,
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainScreen(),
                      ),
                    );
                  },
                  child: BaseText(
                    localization.skip,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: kcPrimaryColor,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
