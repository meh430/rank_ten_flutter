import 'package:flutter/foundation.dart';
import 'package:rank_ten/api/preferences_store.dart';
import 'package:rank_ten/api/rank_api.dart';
import 'package:rank_ten/models/user.dart';

class Authorization {
  static RankApi _api = RankApi();
  static PreferencesStore _store = PreferencesStore();

  static Future<dynamic> tokenValid(String token) async {
    var response =
        await _api.post(endpoint: '/validate_token', bearerToken: token);
    var user = User.fromJson(response);
    return user;
  }

  static Future<User> loginUser(
      {@required String userName, @required String password}) async {
    var response = await _api.post(
        endpoint: '/login', data: {'username': userName, 'password': password});
    var user = User.fromJson(response);
    _store.saveCred(user.jwtToken, userName, password);
    return user;
  }

  static Future<User> signupUser(
      {@required String userName,
      @required String password,
      @required String bio}) async {
    var response = await _api.post(
        endpoint: '/signup',
        data: {'username': userName, 'password': password, 'bio': bio});

    var user = User.fromJson(response);
    _store.saveCred(user.jwtToken, userName, password);
    return user;
  }
}
