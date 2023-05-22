import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_woocommerce/core/colors.dart";
import "package:flutter_woocommerce/core/ui_helpers.dart";
import "package:flutter_woocommerce/core/widgets/base_button.dart";
import "package:flutter_woocommerce/core/widgets/toast.dart";
import "package:flutter_woocommerce/features/authentication/presentation/bloc/sign_from/bloc.dart";
import "package:flutter_woocommerce/features/authentication/presentation/screens/sign_in_screen.dart";
import "package:flutter_woocommerce/main_screen.dart";
import "package:iconly/iconly.dart";
import "../../../../core/error/failures.dart";
import "../bloc/bloc.dart";

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final circularBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
  );

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
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
              if (l == AuthFailure(AuthFailureType.userNameAlreadyTaken)) {
                message = 'User Name already in use';
              } else if (l == AuthFailure(AuthFailureType.serverError)) {
                message = 'Server error';
              } else if (l == AuthFailure(AuthFailureType.emailAlreadyTaken)) {
                message = 'Email already in use';
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
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  children: [
                    verticalSpaceLarge,
                    Text('Sign up',
                        style: Theme.of(context).textTheme.bodyLarge),
                    verticalSpaceLarge,
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            style: theme.textTheme.bodyMedium,
                            decoration: InputDecoration(
                              hintText: 'Name',
                              hintStyle:
                                  Theme.of(context).textTheme.titleMedium,
                              prefixIcon: Icon(
                                IconlyBold.profile,
                                color: kcIconColorSelected,
                              ),
                              filled: true,
                              fillColor: kcSecondaryColor,
                              border: circularBorder.copyWith(
                                borderSide:
                                    BorderSide(color: kcSecondaryColor),
                              ),
                              errorBorder: circularBorder.copyWith(
                                borderSide:
                                    const BorderSide(color: Colors.red),
                              ),
                              focusedBorder: circularBorder.copyWith(
                                borderSide: BorderSide(color: kcPrimaryColor),
                              ),
                              enabledBorder: circularBorder.copyWith(
                                borderSide:
                                    BorderSide(color: kcSecondaryColor),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight(context) * .02),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              } else if (RegExp(
                                    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
                                  ).hasMatch(value) ==
                                  false) {
                                return "email is not valid";
                              }
                              return null;
                            },
                            style: theme.textTheme.bodyMedium,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle:
                                  Theme.of(context).textTheme.titleMedium,
                              prefixIcon: Icon(
                                IconlyBold.message,
                                color: kcIconColorSelected,
                              ),
                              filled: true,
                              fillColor: kcSecondaryColor,
                              border: circularBorder.copyWith(
                                borderSide:
                                    BorderSide(color: kcSecondaryColor),
                              ),
                              errorBorder: circularBorder.copyWith(
                                borderSide:
                                    const BorderSide(color: Colors.red),
                              ),
                              focusedBorder: circularBorder.copyWith(
                                borderSide: BorderSide(color: kcPrimaryColor),
                              ),
                              enabledBorder: circularBorder.copyWith(
                                borderSide:
                                    BorderSide(color: kcSecondaryColor),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight(context) * .02),
                          TextFormField(
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              } else if (RegExp(r'^.{6,10}$')
                                      .hasMatch(value) ==
                                  false) {
                                return "password is too short";
                              }
                              return null;
                            },
                            obscureText: true,
                            style: theme.textTheme.bodyMedium,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle:
                                  Theme.of(context).textTheme.titleMedium,
                              prefixIcon: Icon(
                                IconlyBold.lock,
                                color: kcIconColorSelected,
                              ),
                              filled: true,
                              fillColor: kcSecondaryColor,
                              border: circularBorder.copyWith(
                                borderSide:
                                    BorderSide(color: kcSecondaryColor),
                              ),
                              errorBorder: circularBorder.copyWith(
                                borderSide:
                                    const BorderSide(color: Colors.red),
                              ),
                              focusedBorder: circularBorder.copyWith(
                                borderSide: BorderSide(color: kcPrimaryColor),
                              ),
                              enabledBorder: circularBorder.copyWith(
                                borderSide:
                                    BorderSide(color: kcSecondaryColor),
                              ),
                            ),
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
                          title: "CREATE ACCOUNT",
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
                          child: const Text(
                            'OR SIGN IN',
                            style: TextStyle(
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
