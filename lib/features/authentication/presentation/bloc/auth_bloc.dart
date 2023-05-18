import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/features/authentication/presentation/bloc/bloc.dart';
import '../../data/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc({required this.authRepository}) : super(Uninitialized()) {
    on<AuthenticationStarted>(
      (event, emit) {
        bool isLoggedIn = authRepository.isLoggedIn();
        if (isLoggedIn) {
          final loggedInUser = authRepository.getSignedInUser();
          emit(Authenticated(loggedInUser!));
        } else {
          emit(Unauthenticated());
        }
      },
    );
    on<LoggedOut>(
      (event, emit) {
        authRepository.logOut();
        emit(Unauthenticated());
      },
    );
    on<LoggedIn>(
      (event, emit) async {
        final loggedInUser = authRepository.getSignedInUser();
        emit(Authenticated(loggedInUser!));
      },
    );
  }
}
