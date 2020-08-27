import 'package:rank_ten/api/rank_api.dart';
import 'package:rank_ten/models/ranked_list.dart';

class RankListRepository {
  RankApi _api = RankApi();

  Future<RankedList> getRankedList(String listId) async {
    var response = await _api.get(endpoint: '/rankedlist/$listId');
    var rankedList = RankedList.fromJson(response);

    return rankedList;
  }
}
