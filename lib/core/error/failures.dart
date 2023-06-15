import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class AuthFailure extends Failure {
  final AuthFailureType failureType;

  AuthFailure(this.failureType);
  @override
  List<Object> get props => [failureType];
}

enum AuthFailureType {
  emailAlreadyTaken,
  userNameAlreadyTaken,
  serverError,
  invalidUserName,
  invalidPassword,
}

const List errorStatusCodes = [400, 401, 404, 403,500];
