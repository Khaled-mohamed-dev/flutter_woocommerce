import 'package:equatable/equatable.dart';

import '../../data/models/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class Uninitialized extends AuthState {}

class Authenticated extends AuthState {
  final User loggedInUser;

  const Authenticated(this.loggedInUser);

  @override
  List<Object?> get props => [loggedInUser];

  @override
  String toString() {
    return 'Authenticated{email: ${loggedInUser.email}}';
  }
}

class Unauthenticated extends AuthState {}
