import 'package:flutter/material.dart';
import 'package:rank_ten/api/rank_api.dart';
import 'package:rank_ten/models/ranked_list.dart';

class RankedListRepository {
  Future<RankedList> getRankedList(int listId) async {
    var response = await RankApi.get(endpoint: '/rankedlist/$listId');
    var rankedList = RankedList.fromJson(response);

    return rankedList;
  }

  Future<dynamic> createRankedList(
      {@required RankedList rankedList, @required String token}) async {
    var response = await RankApi.post(
        endpoint: '/rankedlist', data: rankedList.toJson(), bearerToken: token);

    return response;
  }

  Future<dynamic> updateRankedList(
      {@required RankedList rankedList,
      @required int listId,
      @required String token}) async {
    var response = await RankApi.put(
        endpoint: '/rankedlist/$listId',
        data: rankedList.toJson(),
        bearerToken: token);

    return response;
  }

  Future<dynamic> deleteRankedList(
      {@required int listId, @required String token}) async {
    var response = await RankApi.delete(
        endpoint: '/rankedlist/$listId', bearerToken: token);
    return response;
  }
}
