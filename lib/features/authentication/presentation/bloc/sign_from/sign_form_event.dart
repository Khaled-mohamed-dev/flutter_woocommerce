import 'package:equatable/equatable.dart';

abstract class SignFormEvent extends Equatable {
  const SignFormEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends SignFormEvent {
  final String email;

  const EmailChanged({required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() {
    return 'EmailChanged{email: $email}';
  }
}

/// When user changes password
class PasswordChanged extends SignFormEvent {
  final String password;

  const PasswordChanged({required this.password});

  @override
  List<Object> get props => [];

  @override
  String toString() {
    return 'PasswordChanged{password: $password}';
  }
}

class RegisterWithEmailAndPasswordPressed extends SignFormEvent {
  final String emailAdress;
  final String password;
  final String name;

  const RegisterWithEmailAndPasswordPressed({
    required this.emailAdress,
    required this.password,
    required this.name,
  });

  @override
  List<Object> get props => [emailAdress, password, name];
}

class SignInWithEmailAndPasswordPressed extends SignFormEvent {
  final String emailAdress;
  final String password;

  const SignInWithEmailAndPasswordPressed(
      {required this.emailAdress, required this.password});
  @override
  List<Object> get props => [emailAdress, password];
}

class SetupAccount extends SignFormEvent {
  final String fullName;
  final String address;
  final String phoneNumber;
  const SetupAccount(
      {required this.fullName,
      required this.address,
      required this.phoneNumber});
}
