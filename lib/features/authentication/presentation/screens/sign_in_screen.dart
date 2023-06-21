import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_woocommerce/core/colors.dart";
import "package:flutter_woocommerce/core/ui_helpers.dart";
import "package:flutter_woocommerce/core/widgets/base_button.dart";
import "package:flutter_woocommerce/core/widgets/base_text.dart";
import "package:flutter_woocommerce/core/widgets/custome_text_field.dart";
import "package:flutter_woocommerce/core/widgets/toast.dart";
import "package:flutter_woocommerce/features/authentication/presentation/screens/sign_up_screen.dart";
import "package:flutter_woocommerce/main_screen.dart";
import "package:iconly/iconly.dart";
import "../../../../core/error/failures.dart";
import "../bloc/sign_from/sign_form_bloc.dart";
import "../bloc/sign_from/sign_form_event.dart";
import "../bloc/sign_from/sign_form_state.dart";
import "../bloc/bloc.dart";
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SignupViewState();
}

class _SignupViewState extends State<SigninScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    Theme.of(context);
    return BlocConsumer<SignFormBloc, SignFormState>(
      listener: (context, state) {
        state.authFailureOrSuccessOption.fold(
          () {},
          (either) => either.fold(
            (l) {
              var message = '';
              if (l == AuthFailure(AuthFailureType.serverError)) {
                message = 'Server error';
              } else if (l == AuthFailure(AuthFailureType.invalidPassword)) {
                message = "the password you entered is wrong";
              } else if (l == AuthFailure(AuthFailureType.invalidUserName)) {
                message = "The user name or email doesn't exist";
              }
              showToast(message);
            },
            (r) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainScreen(),
                ),
              );
              BlocProvider.of<AuthBloc>(context).add(LoggedIn());
            },
          ),
        );
      },
      builder: (context, state) {
        return Scaffold(
          // resizeToAvoidBottomInset: false,
          body: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BaseText(
                  localization.sign_in,
                  style: Theme.of(context).textTheme.bodyLarge!,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight(context) * .02),
                      CustomTextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        hint: localization.email,
                        icon: IconlyBold.message,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
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
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        isPassword: true,
                      ),
                      SizedBox(height: screenHeight(context) * .04),
                    ],
                  ),
                ),
                Column(
                  children: [
                    BaseButton(
                      icon: Icons.arrow_forward_sharp,
                      title: localization.sign_in,
                      callback: () {
                        if (_formKey.currentState!.validate()) {
                          BlocProvider.of<SignFormBloc>(context).add(
                            SignInWithEmailAndPasswordPressed(
                              emailAdress: _emailController.text.trim(),
                              password: _passwordController.text,
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
                            builder: ((context) => const SignupScreen()),
                          ),
                        );
                      },
                      child: BaseText(
                        localization.or_sign_up,
                        style: const TextStyle(
                          color: kcMediumGreyColorLightTheme,
                          decoration: TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.dotted,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
