import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_woocommerce/features/authentication/data/repositories/auth_repository.dart';
import 'package:flutter_woocommerce/features/authentication/presentation/bloc/sign_from/bloc.dart';

class SignFormBloc extends Bloc<SignFormEvent, SignFormState> {
  final AuthRepository authRepository;
  SignFormBloc({
    required this.authRepository,
  }) : super(SignFormState.initial()) {
    // on<EmailChanged>(
    //   (event, emit) => emit(
    //     state.copyWith(
    //       emailAdress: event.email,
    //       authFailureOrSuccessOption: none(),
    //     ),
    //   ),
    // );
    // on<PasswordChanged>(
    //   (event, emit) => emit(
    //     state.copyWith(
    //       password: event.password,
    //       authFailureOrSuccessOption: none(),
    //     ),
    //   ),
    // );

    on<RegisterWithEmailAndPasswordPressed>(
      (event, emit) async {
        emit(
          state.copyWith(
            isSubmitting: true,
            authFailureOrSuccessOption: none(),
          ),
        );

        var failureOrsuccess = await authRepository.register(
          emailAddress: event.emailAdress,
          password: event.password,
          userName: event.name,
        );

        emit(
          state.copyWith(
            isSubmitting: false,
            authFailureOrSuccessOption: optionOf(failureOrsuccess),
          ),
        );
      },
    );

    on<SignInWithEmailAndPasswordPressed>(
      (event, emit) async {
        emit(
          state.copyWith(
            isSubmitting: true,
            authFailureOrSuccessOption: none(),
          ),
        );

        var failureOrsuccess = await authRepository.signInWithEmailAndPassword(
          userName: event.emailAdress,
          password: event.password,
        );

        emit(
          state.copyWith(
            isSubmitting: false,
            authFailureOrSuccessOption: optionOf(failureOrsuccess),
          ),
        );
      },
    );
  }
}
