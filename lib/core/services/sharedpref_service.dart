import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/authentication/data/models/user.dart';
import '../../main.dart';

class SharedPrefService {
  // static SharedPrefService? _instance;
  // static SharedPreferences? _preferences;

  // static Future<SharedPrefService?> getInstance() async {
  //   _instance ??= SharedPrefService();
  //   _preferences ??= await SharedPreferences.getInstance();
  //   return _instance;
  // }
  final SharedPreferences sharedPreferences;
  SharedPrefService({required this.sharedPreferences});

  void _removeFromDisk(String key) {
    logger.d(
        '(TRACE) LocalStorageService:_removeFromDisk. key: $key');
    sharedPreferences.remove(key);
  }

  dynamic _getFromDisk(String key) {
    var value = sharedPreferences.get(key);
    // logger
    //     .d('(TRACE) LocalStorageService:_getFromDisk. key: $key value: $value');
    return value;
  }

  void _saveToDisk<T>(String key, T content) {
    var preferences = sharedPreferences;
    // logger.d(
    //     '(TRACE) LocalStorageService:_saveStringToDisk. key: $key value: $content');
    if (content is String) {
      preferences.setString(key, content);
    }
    if (content is bool) {
      preferences.setBool(key, content);
    }
    if (content is int) {
      preferences.setInt(key, content);
    }
    if (content is double) {
      preferences.setDouble(key, content);
    }
    if (content is List<String>) {
      preferences.setStringList(key, content);
    }
  }

  //----------------------//----------------------//----------------------//----------------------//----------------------//----------------------//-----------------//

  static const String userKey = 'user';

  User? get user {
    var userJson = _getFromDisk(userKey);
    if (userJson == null) {
      return null;
    }
    return User.fromJson(json.decode(userJson));
  }

  set user(User? userToSave) {
    if (userToSave == null) {
      _removeFromDisk(userKey);
    } else {
      _saveToDisk(userKey, json.encode(userToSave.toJson()));
    }
  }

  static const String favoritesKey = 'favorites';

  List<String> get favorites {
    List<String>? favoritesIDs = (_getFromDisk(favoritesKey) as List?)
        ?.map((e) => e.toString())
        .toList();
    if (favoritesIDs == null) {
      return [];
    }
    return favoritesIDs;
  }

  set favorites(List favoritesIDs) {
    _saveToDisk(favoritesKey, favoritesIDs);
  }

  static const String themeKey = 'theme';

  String get theme {
    return _getFromDisk(themeKey) ?? 'dark';
  }

  set theme(String theme) {
    _saveToDisk(themeKey, theme);
  }
}


  // Future<bool> verifyUserLogin({
  //   required String userName,
  //   required String password,
  // }) async {
  //   try {
  //     var response = await httpClient.post(
  //       Uri.parse('${jwtAuth}token'),
  //       headers: {
  //         "Accept": "application/json",
  //       },
  //       body: {
  //         "username": userName,
  //         "password": password,
  //       },
  //     );

  //     if (response.statusCode != 200) {
  //       logger.e(response.body);
  //       String code = jsonDecode(response.body)["code"];
  //       if (code.contains('invalid_username')) {
  //         throw AuthFailure(AuthFailureType.invalidUserName);
  //       } else if (code.contains('incorrect_password')) {
  //         throw AuthFailure(AuthFailureType.incorrectPassword);
  //       }
  //       throw ServerFailure();
  //     }
  //     var result = response.body;
  //     logger.d(result);
  //     return true;
  //   } catch (e) {
  //     logger.e('$e');
  //     throw Left(ServerFailure());
  //   }
  // }
