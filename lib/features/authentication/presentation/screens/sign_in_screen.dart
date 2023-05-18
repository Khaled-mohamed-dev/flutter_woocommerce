import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_woocommerce/core/colors.dart";
import "package:flutter_woocommerce/core/ui_helpers.dart";
import "package:flutter_woocommerce/core/widgets/base_button.dart";
import "package:flutter_woocommerce/core/widgets/toast.dart";
import "package:flutter_woocommerce/features/authentication/presentation/screens/sign_up_screen.dart";
import "package:flutter_woocommerce/main_screen.dart";
import "package:iconly/iconly.dart";
import "../../../../core/error/failures.dart";
import "../bloc/sign_from/sign_form_bloc.dart";
import "../bloc/sign_from/sign_form_event.dart";
import "../bloc/sign_from/sign_form_state.dart";
import "../bloc/bloc.dart";

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SignupViewState();
}

class _SignupViewState extends State<SigninScreen> {
  final circularBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
  );
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
        var theme = Theme.of(context);
        return Scaffold(
          // resizeToAvoidBottomInset: false,
          body: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Sign in', style: Theme.of(context).textTheme.bodyLarge),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight(context) * .02),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          // } else if (RegExp(
                          //       r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
                          //     ).hasMatch(value) ==
                          //     false) {
                          //   return "email is not valid";
                          // }
                          return null;
                        },
                        style: theme.textTheme.bodyMedium,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: Theme.of(context).textTheme.titleMedium,
                          prefixIcon: Icon(
                            IconlyBold.message,
                            color: kcIconColorSelected,
                          ),
                          // prefixIconColor:kcPrimaryColor,
                          focusColor: kcPrimaryColor,
                          iconColor: kcPrimaryColor,
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
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        obscureText: true,
                        style: theme.textTheme.bodyMedium,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: Theme.of(context).textTheme.titleMedium,
                          prefixIcon: Icon(
                            IconlyBold.lock,
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
                Column(
                  children: [
                    BaseButton(
                      icon: Icons.arrow_forward_sharp,
                      title: "SIGN IN",
                      callback: () {
                        if (_formKey.currentState!.validate()) {
                          BlocProvider.of<SignFormBloc>(context).add(
                            SignInWithEmailAndPasswordPressed(
                              emailAdress: _emailController.text,
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
                      child: const Text(
                        'OR SIGN UP',
                        style: TextStyle(
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
