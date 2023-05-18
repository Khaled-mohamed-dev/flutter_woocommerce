import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';

class SignFormState {
  final String emailAdress;
  final String password;
  final bool isSubmitting;
  final Option<Either<Failure, Unit>> authFailureOrSuccessOption;

  SignFormState({
    required this.emailAdress,
    required this.password,
    required this.isSubmitting,
    required this.authFailureOrSuccessOption,
  });

  factory SignFormState.initial() => SignFormState(
        emailAdress: "",
        password: "",
        isSubmitting: false,
        authFailureOrSuccessOption: none(),
      );

  SignFormState copyWith(
          {String? emailAdress,
          String? password,
          bool? isSubmitting,
          Option<Either<Failure, Unit>>? authFailureOrSuccessOption}) =>
      SignFormState(
          emailAdress: emailAdress ?? this.emailAdress,
          password: password ?? this.password,
          isSubmitting: isSubmitting ?? this.isSubmitting,
          authFailureOrSuccessOption:
              authFailureOrSuccessOption ?? this.authFailureOrSuccessOption);
}
