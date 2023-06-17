import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_woocommerce/core/colors.dart";
import "package:flutter_woocommerce/core/ui_helpers.dart";
import "package:flutter_woocommerce/core/widgets/base_button.dart";
import "package:flutter_woocommerce/core/widgets/base_text.dart";
import "package:flutter_woocommerce/core/widgets/custome_text_field.dart";
import "package:flutter_woocommerce/core/widgets/toast.dart";
import "package:flutter_woocommerce/features/authentication/presentation/bloc/sign_from/bloc.dart";
import "package:flutter_woocommerce/features/authentication/presentation/screens/setup_account_screen.dart";
import "package:flutter_woocommerce/features/authentication/presentation/screens/sign_in_screen.dart";
import "package:iconly/iconly.dart";
import "../../../../core/error/failures.dart";
import "../bloc/bloc.dart";
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    var localization = AppLocalizations.of(context)!;

    return BlocConsumer<SignFormBloc, SignFormState>(
      listener: (context, state) {
        state.authFailureOrSuccessOption.fold(
          () {},
          (either) => either.fold(
            (l) {
              var message = '';
              if (l == AuthFailure(AuthFailureType.userNameAlreadyTaken)) {
                message = localization.username_aleady_exists;
              } else if (l == AuthFailure(AuthFailureType.serverError)) {
                message = 'Server error';
              } else if (l == AuthFailure(AuthFailureType.emailAlreadyTaken)) {
                message = localization.email_aleady_exists;
              }
              showToast(message);
            },
            (r) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SetupAccountScreen(),
                ),
              );
              BlocProvider.of<AuthBloc>(context).add(LoggedIn());
            },
          ),
        );
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  children: [
                    verticalSpaceLarge,
                    BaseText(
                      localization.sign_up,
                      style: Theme.of(context).textTheme.bodyLarge!,
                    ),
                    verticalSpaceLarge,
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _nameController,
                            hint: localization.username,
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
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            hint: localization.email,
                            icon: IconlyBold.message,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return localization.required_field;
                              } else if (RegExp(
                                    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
                                  ).hasMatch(value) ==
                                  false) {
                                return localization.email_not_valid;
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenHeight(context) * .02),
                          CustomTextField(
                            controller: _passwordController,
                            hint: localization.password,
                            icon: IconlyBold.lock,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return localization.required_field;
                              } else if (RegExp(r'^.{6,}$').hasMatch(value) ==
                                  false) {
                                return localization.short_password;
                              }
                              return null;
                            },
                            isPassword: true,
                          ),
                          SizedBox(height: screenHeight(context) * .04),
                        ],
                      ),
                    ),
                    verticalSpaceLarge,
                    Column(
                      children: [
                        BaseButton(
                          icon: Icons.arrow_forward_sharp,
                          title: localization.create_account,
                          callback: () {
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<SignFormBloc>(context).add(
                                RegisterWithEmailAndPasswordPressed(
                                  emailAdress: _emailController.text,
                                  password: _passwordController.text,
                                  name: _nameController.text,
                                ),
                              );
                            }
                          },
                          isLoading: state.isSubmitting,
                        ),
                        SizedBox(height: screenHeight(context) * .03),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => const SigninScreen()),
                              ),
                            );
                          },
                          child: BaseText(
                            localization.or_sign_in,
                            style: const TextStyle(
                              color: kcMediumGreyColorLightTheme,
                              decoration: TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.dotted,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
