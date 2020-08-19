import 'package:rank_ten/api/rank_api.dart';
import 'package:rank_ten/models/user.dart';
import 'package:rank_ten/preferences_store.dart';

class Authorization {
  static RankApi _api = RankApi();
  static PreferencesStore _store = PreferencesStore();

  static Future<dynamic> tokenValid(String token) async {
    var response =
        await _api.post(endpoint: '/validate_token', bearerToken: token);

    var user = User.fromJson(response);
    return user;
  }

  static Future<User> loginUser({String userName, String password}) async {
    var response = await _api.post(
        endpoint: '/login',
        data: {'user_name': userName, 'password': password});

    var user = User.fromJson(response);
    _store.saveCred(user.jwtToken, userName, password);
    return user;
  }

  static Future<User> signupUser(
      {String userName, String password, String bio}) async {
    var response = await _api.post(
        endpoint: '/signup',
        data: {'user_name': userName, 'password': password, 'bio': bio});

    var user = User.fromJson(response);
    _store.saveCred(user.jwtToken, userName, password);
    return user;
  }
}
