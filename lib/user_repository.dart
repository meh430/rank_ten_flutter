import 'package:rank_ten/api/rank_api.dart';
import 'package:rank_ten/app.dart';

import 'models/user.dart';

class UserRepository {
  RankApi _api = RankApi();

  Future<User> getUser(String name) async {
    final response = await _api.get(
        endpoint: '/users/$name', bearerToken: mainUser.jwtToken);
    return User.fromJson(response);
  }

  Future<dynamic> updateBio(String bio) async {
    final response = await _api.put(
        endpoint: '/users', data: {'bio': bio}, bearerToken: mainUser.jwtToken);
    return response;
  }

  Future<dynamic> updateProfilePic(String profPic) async {
    final response = await _api.put(
        endpoint: '/users',
        data: {'prof_pic': profPic},
        bearerToken: mainUser.jwtToken);
    return response;
  }

  Future<dynamic> followUser(String name) async {
    final response = await _api.post(
        endpoint: '/follow/$name', bearerToken: mainUser.jwtToken);

    if (response['message'].contains("follow")) {
      return "FOLLOW";
    } else {
      return "UNFOLLOW";
    }
  }
}
