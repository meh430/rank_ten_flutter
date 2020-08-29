import 'package:flutter/material.dart';
import 'package:rank_ten/api/rank_api.dart';
import 'package:rank_ten/models/ranked_list.dart';

class RankedListRepository {
  RankApi _api = RankApi();

  Future<RankedList> getRankedList(String listId) async {
    var response = await _api.get(endpoint: '/rankedlist/$listId');
    var rankedList = RankedList.fromJson(response);

    return rankedList;
  }

  Future<dynamic> createRankedList(
      {@required RankedList rankedList, @required String token}) async {
    var response = await _api.post(
        endpoint: '/rankedlist', data: rankedList.toJson(), bearerToken: token);

    return response;
  }

  Future<dynamic> updateRankedList(
      {@required RankedList rankedList,
      @required String listId,
      @required String token}) async {
    var response = await _api.put(
        endpoint: '/rankedlist/$listId',
        data: rankedList.toJson(),
        bearerToken: token);

    return response;
  }

  Future<dynamic> deleteRankedList(
      {@required String listId, @required String token}) async {
    var response =
        await _api.delete(endpoint: '/rankedlist/$listId', bearerToken: token);
    return response;
  }
}
