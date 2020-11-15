import 'package:flutter/foundation.dart';
import 'package:rank_ten/api/rank_api.dart';
import 'package:rank_ten/api/rank_exceptions.dart';
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
        endpoint =
            '/rankedlists${token.isNotEmpty ? 'p' : ''}/${token.isEmpty ? name + '/' : ''}1/$sort';
        break;
      case SEARCH_LISTS:
        query = query.replaceAll(" ", "+");
        endpoint += '/$page/$sort?q=$query';
        break;
    }

    if (refresh) {
      if (endpointBase == SEARCH_LISTS) {
        endpoint += '&re=True';
      } else {
        endpoint += '?re=True';
      }
    }



    final response = await _api.get(endpoint: endpoint, bearerToken: token);
    var listPreviews = List<RankedListCard>();
    if(response[0] is String && response[0].contains("page")) {
      return [];
    }

    response
        .forEach((rList) => listPreviews.add(RankedListCard.fromJson(rList)));

    if (endpointBase == USER_TOP_LISTS && listPreviews.length >= 5) {
      return listPreviews.sublist(0, 5);
    }

    return listPreviews;
  }
}
