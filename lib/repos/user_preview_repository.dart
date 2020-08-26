import 'package:flutter/foundation.dart';
import 'package:rank_ten/api/rank_api.dart';
import 'package:rank_ten/models/user.dart';

//id
const LIKED_USERS = 'like';
//page, sort, query
const SEARCH_USERS = 'search_users';
//name
const FOLLOWING_USERS = 'following';
//name
const FOLLOWERS_USERS = 'followers';

class UserPreviewRepository {
  RankApi _api = RankApi();

  Future<List<UserPreview>> getUserPreview(
      {@required String endpointBase,
      String name,
      int page,
      int sort,
      String query,
      bool refresh = false}) async {
    String endpoint = '/$endpointBase';

    switch (endpointBase) {
      case LIKED_USERS:
        endpoint += '/$name';
        break;
      case FOLLOWERS_USERS:
        endpoint += '/$name';
        break;
      case FOLLOWING_USERS:
        endpoint += '/$name';
        break;
      case SEARCH_USERS:
        query = query.replaceAll(" ", "+");
        endpoint += '/$page/$sort?q=$query';
        break;
    }

    if (refresh) {
      endpoint += '?re=True';
    }

    final response = await _api.get(endpoint: endpoint);
    var userPreviews = List<UserPreview>();
    response.forEach(
        (userPrev) => userPreviews.add(UserPreview.fromJson(userPrev)));

    return userPreviews;
  }
}
