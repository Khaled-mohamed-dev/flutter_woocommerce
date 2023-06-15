import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:collection/collection.dart';

import 'package:flutter_woocommerce/core/services/sharedpref_service.dart';
import '../../../../core/consts.dart';
import '../../../../core/error/failures.dart';
import '../../../../main.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

abstract class AuthRepository {
  bool isLoggedIn();

  User? getSignedInUser();

  Future<Either<Failure, Unit>> register({
    required String emailAddress,
    required String password,
    required String userName,
  });

  Future<Either<Failure, Unit>> setupAccount({required User user});

  Future<Either<Failure, Unit>> signInWithEmailAndPassword({
    required String userName,
    required String password,
  });

  void logOut();
}

class AuthRepositoryImpl implements AuthRepository {
  final http.Client client;
  final SharedPrefService sharedPrefService;

  AuthRepositoryImpl({required this.client, required this.sharedPrefService});

  @override
  User? getSignedInUser() {
    return sharedPrefService.user;
  }

  @override
  bool isLoggedIn() => sharedPrefService.user != null;

  @override
  void logOut() {
    if (sharedPrefService.user != null) {
      sharedPrefService.user = null;
    }
  }

  @override
  Future<Either<Failure, Unit>> register({
    required String emailAddress,
    required String password,
    required String userName,
  }) async {
    try {
      // Check if the email is already taken
      var userResponse = await client
          .get(Uri.parse('${wcAPI}customers?email=$emailAddress&$wcCred'));

      if (errorStatusCodes.contains(userResponse.statusCode)) {
        logger.e(userResponse.body);
        return Left(ServerFailure());
      }

      List<User> userResult = userFromJson(userResponse.body);

      if (userResult.isNotEmpty) {
        logger.e(AuthFailure(AuthFailureType.emailAlreadyTaken));
        return Left(AuthFailure(AuthFailureType.emailAlreadyTaken));
      }

      // check if the userName is already taken

      var userNameResponse = await client
          .get(Uri.parse('${wcAPI}customers?search=$userName&$wcCred'));

      if (errorStatusCodes.contains(userNameResponse.statusCode)) {
        logger.e(userNameResponse.body);
        return Left(ServerFailure());
      }

      List<User> userNameResult = userFromJson(userNameResponse.body);

      if (userNameResult.firstWhereOrNull((element) =>
              element.username!.toLowerCase() == userName.toLowerCase()) !=
          null) {
        logger.e(AuthFailure(AuthFailureType.userNameAlreadyTaken));
        return Left(AuthFailure(AuthFailureType.userNameAlreadyTaken));
      }

      // if everything checks out and the email and userName are not taken then add the customer to the database

      var registeredUser = await client.post(
        Uri.parse('${wcAPI}customers?$wcCred'),
        body: json.encode(
          {
            'email': emailAddress,
            'username': userName,
            'password': password,
            'billing': {'email': emailAddress},
            'shipping': {'email': emailAddress}
          },
        ),
        headers: {
          "content-type": "application/json",
        },
      );

      sharedPrefService.user = User.fromJson(jsonDecode(registeredUser.body));

      return const Right(unit);
    } catch (e) {
      logger.wtf(e);
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> setupAccount({required User user}) async {
    try {
      var updatedUser = await client.put(
        Uri.parse('${wcAPI}customers/${user.id}?$wcCred'),
        body: json.encode(user.toJson()),
        headers: {
          "content-type": "application/json",
        },
      );

      if (errorStatusCodes.contains(updatedUser.statusCode)) {
        logger.e(updatedUser.body);
        return Left(ServerFailure());
      }

      logger.w(updatedUser.body);

      sharedPrefService.user = User.fromJson(jsonDecode(updatedUser.body));

      return const Right(unit);
    } catch (e) {
      logger.e(e);
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> signInWithEmailAndPassword(
      {required String userName, required String password}) async {
    try {
      var response = await client.post(
        Uri.parse('${jwtAuth}token'),
        body: json.encode({
          "username": userName,
          "password": password,
        }),
        headers: {
          "content-type": "application/json",
        },
      );

      logger.wtf(response.body);

      if (errorStatusCodes.contains(response.statusCode)) {
        logger.e(response.body);
        String code = jsonDecode(response.body)['code'];
        if (code.contains('invalid_username')) {
          return Left(AuthFailure(AuthFailureType.invalidUserName));
        } else if (code.contains('incorrect_password')) {
          return Left(AuthFailure(AuthFailureType.invalidPassword));
        } else if (code.contains('invalid_email')) {
          return Left(AuthFailure(AuthFailureType.invalidUserName));
        }
        return Left(ServerFailure());
      }

      var userResponse = await client.get(
        Uri.parse('${wcAPI}customers?search=$userName&$wcCred'),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (errorStatusCodes.contains(userResponse.statusCode)) {
        logger.e(userResponse.body);
        return Left(ServerFailure());
      }

      logger.w(userResponse.body);

      List<User> userResult = userFromJson(userResponse.body);

      if (userResult.firstWhereOrNull((element) =>
              element.email!.toLowerCase() == userName.toLowerCase()) !=
          null) {
        sharedPrefService.user = userResult.firstWhere((element) =>
            element.email!.toLowerCase() == userName.toLowerCase());
      } else {
        sharedPrefService.user = userResult.firstWhere((element) =>
            element.username!.toLowerCase() == userName.toLowerCase());
      }

      var result = response.body;
      logger.d(result);
      return const Right(unit);
    } catch (e) {
      logger.e(e);
      
      logger.e('$e');
      return Left(ServerFailure());
    }
  }
}
