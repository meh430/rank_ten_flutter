import 'package:rank_ten/api/rank_api.dart';
import 'package:rank_ten/models/comment.dart';

class CommentsRepository {
  RankApi _api = RankApi();

  Future<List<Comment>> getListComments(
      {String listId, int page, int sort}) async {
    var response = await _api.get(endpoint: '/comment/$listId/$page/$sort');
    var comments = List<Comment>();
    response.forEach((c) => comments.add(Comment.fromJson(c)));
    return comments;
  }

  Future<List<Comment>> getUserComments(
      {String token, int page, int sort}) async {
    var response = await _api.get(
        endpoint: '/user_comments/$page/$sort', bearerToken: token);

    var userComments = List<Comment>();
    response.forEach((c) => userComments.add(Comment.fromJson(c)));
    return userComments;
  }

  Future<dynamic> addComment(
      {String listId, String token, String comment}) async {
    var response = await _api.post(
        endpoint: '/comment/$listId',
        data: {'comment': comment},
        bearerToken: token);
    return response;
  }

  Future<dynamic> deleteComment({String commentId, String token}) async {
    var response =
        await _api.delete(endpoint: '/comment/$commentId', bearerToken: token);
    return response;
  }

  Future<dynamic> updateComment(
      {String commentId, String comment, String token}) async {
    var response = await _api.put(
        endpoint: '/comment/$commentId',
        data: {'comment': comment},
        bearerToken: token);

    return response;
  }
}
