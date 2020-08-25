import 'package:flutter/foundation.dart';
import 'package:rank_ten/api/rank_api.dart';
import 'package:rank_ten/misc/utils.dart';
import 'package:rank_ten/models/ranked_list_card.dart';

//page, sort
const DISCOVER_LISTS = 'discover';
//page, sort, token
const LIKED_LISTS = 'likes';
//page, sort, name
const USER_LISTS = 'rankedlists';
//name
const USER_TOP_LISTS = 'rankedlists_top';
//page, sort, token
const USER_LISTS_ALL = 'rankedlistsp';
//page, token
const FEED_LISTS = 'feed';
//page, sort, query
const SEARCH_LISTS = 'search_lists';

class RankedListPreviewRepository {
  RankApi _api = RankApi();

  Future<List<RankedListCard>> getRankedListPreview(
      {@required String endpointBase,
      String name,
      int page,
      int sort,
      String token = "",
      String query,
      bool refresh = false}) async {
    String endpoint = '/$endpointBase';

    switch (endpointBase) {
      case FEED_LISTS:
        endpoint += '/$page';
        break;
      case DISCOVER_LISTS:
        endpoint += '/$page/$sort';
        break;
      case LIKED_LISTS:
        endpoint += '/$page/$sort';
        break;
      case USER_LISTS:
        endpoint += '/$name/$page/$sort';
        break;
      case USER_LISTS_ALL:
        endpoint += '/$page/$sort';
        break;
      case USER_TOP_LISTS:
        endpoint = '/rankedlists/$name/1/$LIKES_DESC';
        break;
      case SEARCH_LISTS:
        query = query.replaceAll(" ", "+");
        endpoint += '/$page/$sort?q=$query';
        break;
    }

    if (refresh) {
      endpoint += '?re=True';
    }

    final response = await _api.get(endpoint: endpoint, bearerToken: token);
    var listPreviews = List<RankedListCard>();
    response
        .forEach((rList) => listPreviews.add(RankedListCard.fromJson(rList)));

    if (endpointBase == USER_TOP_LISTS && listPreviews.length >= 5) {
      return listPreviews.sublist(0, 5);
    }

    return listPreviews;
  }
}
