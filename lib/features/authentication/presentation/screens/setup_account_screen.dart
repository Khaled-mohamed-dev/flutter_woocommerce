import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/core/widgets/base_button.dart';
import 'package:flutter_woocommerce/features/authentication/data/repositories/auth_repository.dart';
import 'package:flutter_woocommerce/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:flutter_woocommerce/features/authentication/presentation/bloc/sign_from/bloc.dart';
import 'package:flutter_woocommerce/locator.dart';
import 'package:iconly/iconly.dart';

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
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fill Your Profile'),
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
                    TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      style: theme.textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Full Name',
                        hintStyle: Theme.of(context).textTheme.titleMedium,
                        prefixIcon: Icon(
                          IconlyBold.profile,
                          color: kcIconColorSelected,
                        ),
                        filled: true,
                        fillColor: kcSecondaryColor,
                        border: circularBorder.copyWith(
                          borderSide: BorderSide(color: kcSecondaryColor),
                        ),
                        errorBorder: circularBorder.copyWith(
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedBorder: circularBorder.copyWith(
                          borderSide: BorderSide(color: kcPrimaryColor),
                        ),
                        enabledBorder: circularBorder.copyWith(
                          borderSide: BorderSide(color: kcSecondaryColor),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight(context) * .02),
                    TextFormField(
                      controller: _addressController,
                      keyboardType: TextInputType.streetAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      style: theme.textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Address',
                        hintStyle: Theme.of(context).textTheme.titleMedium,
                        prefixIcon: Icon(
                          IconlyBold.location,
                          color: kcIconColorSelected,
                        ),
                        filled: true,
                        fillColor: kcSecondaryColor,
                        border: circularBorder.copyWith(
                          borderSide: BorderSide(color: kcSecondaryColor),
                        ),
                        errorBorder: circularBorder.copyWith(
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedBorder: circularBorder.copyWith(
                          borderSide: BorderSide(color: kcPrimaryColor),
                        ),
                        enabledBorder: circularBorder.copyWith(
                          borderSide: BorderSide(color: kcSecondaryColor),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight(context) * .02),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        } 
                        return null;
                      },
                      style: theme.textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Phone number',
                        hintStyle: Theme.of(context).textTheme.titleMedium,
                        prefixIcon: Icon(
                          IconlyBold.call,
                          color: kcIconColorSelected,
                        ),
                        filled: true,
                        fillColor: kcSecondaryColor,
                        border: circularBorder.copyWith(
                          borderSide: BorderSide(color: kcSecondaryColor),
                        ),
                        errorBorder: circularBorder.copyWith(
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedBorder: circularBorder.copyWith(
                          borderSide: BorderSide(color: kcPrimaryColor),
                        ),
                        enabledBorder: circularBorder.copyWith(
                          borderSide: BorderSide(color: kcSecondaryColor),
                        ),
                      ),
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
                  title: 'Continue',
                  callback: () {
                    context.read<SignFormBloc>().add(
                          SetupAccount(
                            fullName: _nameController.text,
                            address: _addressController.text,
                            phoneNumber: _phoneController.text,
                          ),
                        );
                  },
                ),
                verticalSpaceTiny,
                Text(
                  'Skip',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: kcPrimaryColor),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
