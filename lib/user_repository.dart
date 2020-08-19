import 'package:rank_ten/api/rank_api.dart';

import 'models/user.dart';

class UserRepository {
  RankApi _api = RankApi();

  Future<User> getUser(String name) async {
    final response = await _api.get(endpoint: '/users/$name');
    return User.fromJson(response);
  }

  Future<dynamic> updateBio(String bio, String token) async {
    final response = await _api.put(
        endpoint: '/users', data: {'bio': bio}, bearerToken: token);
    return response;
  }

  Future<dynamic> updateProfilePic(String profPic, String token) async {
    final response = await _api.put(
        endpoint: '/users', data: {'prof_pic': profPic}, bearerToken: token);
    return response;
  }

  Future<dynamic> followUser(String name, String token) async {
    final response =
        await _api.post(endpoint: '/follow/$name', bearerToken: token);

    if (response['message'].contains("follow")) {
      return "FOLLOW";
    } else {
      return "UNFOLLOW";
    }
  }
}
