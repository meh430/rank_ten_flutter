import 'package:rank_ten/api/rank_api.dart';
import 'package:rank_ten/api/rank_exceptions.dart';
import 'package:rank_ten/models/user.dart';
import 'package:rank_ten/preferences_store.dart';

class Authorization {
  static RankApi _api = RankApi();
  static PreferencesStore _store = PreferencesStore();

  static Future<dynamic> tokenValid(String token) async {
    var response =
        await _api.post(endpoint: '/validate_token', bearerToken: token);
    if (!(response is RankExceptions)) {
      var user = User.fromJson(response);
      return user;
    }

    return response;
  }

  static Future<dynamic> loginUser({String userName, String password}) async {
    var response = await _api.post(
        endpoint: '/login',
        data: {'user_name': userName, 'password': password});
    if (!(response is RankExceptions)) {
      var user = User.fromJson(response);
      _store.saveCred(user.jwtToken, userName, password);
      return user;
    }

    return response;
  }

  static Future<dynamic> signupUser(
      {String userName, String password, String bio}) async {
    var response = await _api.post(
        endpoint: '/signup',
        data: {'user_name': userName, 'password': password, 'bio': bio});

    print(response);
    if (!(response is RankExceptions)) {
      var user = User.fromJson(response);
      _store.saveCred(user.jwtToken, userName, password);
      return user;
    }

    return response;
  }

  static Future<bool> userAvail(String userName) async {
    var response = await _api.post(endpoint: '/user_avail/$userName');
    if (response['message'].contains('taken')) {
      return false;
    } else {
      return true;
    }
  }
}
