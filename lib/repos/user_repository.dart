import 'package:rank_ten/api/rank_api.dart';

import '../models/user.dart';

enum LikeResponse { liked, unliked, init, error }

enum FollowResponse { followed, unfollowed, init, error }

class UserRepository {
  RankApi _api = RankApi();

  Future<User> getUser(String name) async {
    final response = await _api.get(endpoint: '/users/$name');
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

  Future<FollowResponse> followUser({String name, String token}) async {
    dynamic response;
    try {
      response = await _api.post(endpoint: '/follow/$name', bearerToken: token);
    } catch (e) {
      return FollowResponse.error;
    }

    if (response['message'].contains("unfollow")) {
      return FollowResponse.unfollowed;
    } else {
      return FollowResponse.followed;
    }
  }

  Future<String> likeList({String listId, String token}) async {
    final response =
        await _api.post(endpoint: '/like/$listId', bearerToken: token);

    if (response['message'].contains("unliked")) {
      return "UNLIKED";
    } else {
      return "LIKED";
    }
  }

  Future<String> likeComment({String commentId, String token}) async {
    final response = await _api.post(
        endpoint: '/like_comment/$commentId', bearerToken: token);

    if (response['message'].contains("unliked")) {
      return "UNLIKED";
    } else {
      return "LIKED";
    }
  }

  Future<Set<String>> getLikedListIds({String name, String token}) async {
    final response =
        await _api.get(endpoint: '/likes/1/0?ids=True', bearerToken: token);
    return Set.from(
        List.generate(response.length, (index) => response[index].toString()));
  }
}
