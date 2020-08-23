import 'package:rank_ten/api/rank_api.dart';
import 'package:rank_ten/models/ranked_list_card.dart';

class UserListsRepository {
  RankApi _api = RankApi();

  Future<List<RankedListCard>> getUserRankedLists(
      {String name, int page, int sort}) async {
    final response = await _api.get(endpoint: '/rankedlists/$name/$page/$sort');
    var userLists = List<RankedListCard>();
    response.forEach((rList) => userLists.add(RankedListCard.fromJson(rList)));
    return userLists;
  }
}
