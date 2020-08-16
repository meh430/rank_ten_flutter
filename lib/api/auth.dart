import 'package:rank_ten/api/rank_api.dart';

class Authorization {
  static RankApi _api = RankApi();

  static Future<dynamic> tokenValid(String token) async {
    var response =
        await _api.post(endpoint: '/validate_token', bearerToken: token);
    return response;
  }

  static Future<dynamic> loginUser({String userName, String password}) async {
    var response = await _api.post(
        endpoint: '/login',
        data: {'user_name': userName, 'password': password});
    return response;
  }

  static Future<dynamic> signupUser(
      {String userName, String password, String bio}) async {
    var response = await _api.post(
        endpoint: '/signup',
        data: {'user_name': userName, 'password': password});
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
