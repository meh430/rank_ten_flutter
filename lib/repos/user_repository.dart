import 'package:rank_ten/api/rank_api.dart';

import '../models/user.dart';

enum LikeResponse { liked, unliked, init, error }

enum FollowResponse { followed, unfollowed, init, error }

class UserRepository {
  RankApi _api = RankApi();

  Future<User> getUser(int userId) async {
    final response = await _api.get(endpoint: '/users/$userId');
    return User.fromJson(response);
  }

  Future<dynamic> updateBio({String bio, String token}) async {
    final response = await _api.put(
        endpoint: '/users', data: {'bio': bio}, bearerToken: token);
    return response;
  }

  Future<dynamic> updateProfilePic({String profPic, String token}) async {
    final response = await _api.put(
        endpoint: '/users', data: {'prof_pic': profPic}, bearerToken: token);
    return response;
  }

  Future<FollowResponse> followUser({int userId, String token}) async {
    dynamic response;
    try {
      response =
          await _api.post(endpoint: '/follow/$userId', bearerToken: token);
    } catch (e) {
      return FollowResponse.error;
    }

    if (response['message'].contains("unfollow")) {
      return FollowResponse.unfollowed;
    } else {
      return FollowResponse.followed;
    }
  }

  Future<LikeResponse> likeList({int listId, String token}) async {
    dynamic response;

    try {
      response = await _api.post(endpoint: '/like/$listId', bearerToken: token);
    } catch (e) {
      return LikeResponse.error;
    }

    if (response['message'].contains("unliked")) {
      return LikeResponse.unliked;
    } else {
      return LikeResponse.liked;
    }
  }

  Future<LikeResponse> likeComment({int commentId, String token}) async {
    dynamic response;

    try {
      response = await _api.post(
          endpoint: '/like_comment/$commentId', bearerToken: token);
    } catch (e) {
      return LikeResponse.error;
    }

    if (response['message'].contains("unliked")) {
      return LikeResponse.unliked;
    } else {
      return LikeResponse.liked;
    }
  }
}
