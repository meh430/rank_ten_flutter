import 'package:flutter/foundation.dart';
import 'package:rank_ten/api/rank_api.dart';
import 'package:rank_ten/models/user.dart';

//listId
const LIKED_USERS = 'like';
//page, sort, query
const SEARCH_USERS = 'search_users';
//userId
const FOLLOWING_USERS = 'following';
//userId
const FOLLOWERS_USERS = 'followers';

class UserPreviewRepository {
  Future<dynamic> getUserPreview(
      {@required String endpointBase,
      int id,
      int page,
      int sort,
      String query,
      bool refresh = false}) async {
    String endpoint = '/$endpointBase';

    switch (endpointBase) {
      case LIKED_USERS:
        endpoint += '/$id';
        break;
      case FOLLOWERS_USERS:
        endpoint += '/$id';
        break;
      case FOLLOWING_USERS:
        endpoint += '/$id';
        break;
      case SEARCH_USERS:
        query = query.replaceAll(" ", "+");
        endpoint += '/$page/$sort?q=$query';
        break;
    }

    if (refresh && endpointBase == SEARCH_USERS) {
      endpoint += '&re=True';
    } else if (refresh) {
      endpoint += '?re=True';
    }

    final response = await RankApi.get(endpoint: endpoint);
    var userPreviews = List<UserPreview>();
    if (endpointBase == SEARCH_USERS) {
      response["items"].forEach(
          (userPrev) => userPreviews.add(UserPreview.fromJson(userPrev)));
      response["items"] = userPreviews;
      return response;
    } else {
      response.forEach(
          (userPrev) => userPreviews.add(UserPreview.fromJson(userPrev)));
      return userPreviews;
    }
  }
}
