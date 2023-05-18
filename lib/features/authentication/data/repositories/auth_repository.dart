import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:collection/collection.dart';

import 'package:flutter_woocommerce/core/services/sharedpref_service.dart';
import '../../../../core/consts.dart';
import '../../../../core/error/failures.dart';
import '../../../../main.dart';
import '../models/user.dart';
import 'package:dio/dio.dart';

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
  final Dio dio;
  final SharedPrefService sharedPrefService;

  AuthRepositoryImpl({required this.dio, required this.sharedPrefService});

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

  var responseType = ResponseType.plain;

  @override
  Future<Either<Failure, Unit>> register({
    required String emailAddress,
    required String password,
    required String userName,
  }) async {
    try {
      // Check if the email is already taken
      var userResponse = await dio.get(
        '${wcAPI}customers?email=$emailAddress&$wcCred',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
          responseType: responseType,
        ),
      );

      if ([400, 401, 404, 500].contains(userResponse.statusCode)) {
        logger.e(userResponse.data);
        return Left(ServerFailure());
      }

      List<User> userResult = userFromJson(userResponse.data);

      if (userResult.isNotEmpty) {
        logger.e(AuthFailure(AuthFailureType.emailAlreadyTaken));
        return Left(AuthFailure(AuthFailureType.emailAlreadyTaken));
      }

      // check if the userName is already taken

      var userNameResponse = await dio.get(
        '${wcAPI}customers?search=$userName&$wcCred',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
          responseType: responseType,
        ),
      );

      if ([400, 401, 404, 500].contains(userNameResponse.statusCode)) {
        logger.e(userNameResponse.data);
        return Left(ServerFailure());
      }

      List<User> userNameResult = userFromJson(userNameResponse.data);

      if (userNameResult.firstWhereOrNull((element) =>
              element.username!.toLowerCase() == userName.toLowerCase()) !=
          null) {
        logger.e(AuthFailure(AuthFailureType.userNameAlreadyTaken));
        return Left(AuthFailure(AuthFailureType.userNameAlreadyTaken));
      }

      // if everything checks out and the email and userName are not taken then add the customer to the database

      var registeredUser = await dio.post(
        '${wcAPI}customers?$wcCred',
        data: {
          'email': emailAddress,
          'username': userName,
          'password': password,
          'billing': {'email': emailAddress}
        },
        options: Options(
          headers: {
            "Accept": "application/json",
          },
          responseType: responseType,
        ),
      );

      sharedPrefService.user = User.fromJson(jsonDecode(registeredUser.data));

      return const Right(unit);
    } catch (e) {
      logger.wtf(e);
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> setupAccount({required User user}) async {
    try {
      var updatedUser = await dio.put(
        '${wcAPI}customers/${user.id}?$wcCred',
        data: user.toJson(),
        options: Options(
          headers: {
            "Accept": "application/json",
          },
          responseType: responseType,
        ),
      );

      logger.w(updatedUser.data);

      sharedPrefService.user = User.fromJson(jsonDecode(updatedUser.data));

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
      var response = await dio.post(
        '${jwtAuth}token',
        data: {
          "username": userName,
          "password": password,
        },
        options: Options(
          headers: {
            "Accept": "application/json",
          },
          receiveDataWhenStatusError: true,
          responseType: responseType,
        ),
      );

      var userResponse = await dio.get(
        '${wcAPI}customers?search=$userName&$wcCred',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
          responseType: responseType,
        ),
      );
      logger.w(userResponse.data);

      List<User> userResult = userFromJson(userResponse.data);

      if (userResult.firstWhereOrNull((element) =>
              element.email!.toLowerCase() == userName.toLowerCase()) !=
          null) {
        sharedPrefService.user = userResult.firstWhere((element) =>
            element.email!.toLowerCase() == userName.toLowerCase());
      } else {
        sharedPrefService.user = userResult.firstWhere((element) =>
            element.username!.toLowerCase() == userName.toLowerCase());
      }

      var result = response.data;
      logger.d(result);
      return const Right(unit);
    } on DioError catch (e) {
      logger.e(e.response);
      String code = jsonDecode(e.response.toString())["code"];
      if (code.contains('invalid_username')) {
        return Left(AuthFailure(AuthFailureType.invalidUserName));
      } else if (code.contains('incorrect_password')) {
        return Left(AuthFailure(AuthFailureType.invalidPassword));
      }
      logger.wtf(e.response);
      logger.e('$e');
      return Left(ServerFailure());
    }
  }
}
