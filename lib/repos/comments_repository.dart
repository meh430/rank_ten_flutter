import 'package:rank_ten/api/rank_api.dart';
import 'package:rank_ten/models/comment.dart';

class CommentsRepository {
  Future<Map<String, dynamic>> getListComments(
      {int listId, int page, int sort, bool refresh = false}) async {
    var endpoint = '/comments/$listId/$page/$sort';

    if (refresh) {
      endpoint += '?re=True';
    }

    var response = await RankApi.get(endpoint: endpoint);
    var comments = List<Comment>();
    response["items"].forEach((c) => comments.add(Comment.fromJson(c)));
    response["items"] = comments;
    return response;
  }

  Future<dynamic> getUserComments(
      {String token, int page, int sort, bool refresh = false}) async {
    var endpoint = '/user_comments/$page/$sort';
    if (refresh) {
      endpoint += '?re=True';
    }
    var response = await RankApi.get(endpoint: endpoint, bearerToken: token);

    var userComments = List<Comment>();
    response["items"].forEach((c) => userComments.add(Comment.fromJson(c)));
    response["items"] = userComments;
    return response;
  }

  Future<Comment> addComment({int listId, String token, String comment}) async {
    var response = await RankApi.post(
        endpoint: '/comment/$listId',
        data: {'comment': comment},
        bearerToken: token);
    return Comment.fromJson(response);
  }

  Future<dynamic> deleteComment({int commentId, String token}) async {
    var response = await RankApi.delete(
        endpoint: '/comment/$commentId', bearerToken: token);
    return response;
  }

  Future<Comment> updateComment(
      {int commentId, String comment, String token}) async {
    var response = await RankApi.put(
        endpoint: '/comment/$commentId',
        data: {'comment': comment},
        bearerToken: token);

    return Comment.fromJson(response);
  }

  Future<Map<String, dynamic>> getCommentParent({int commentId}) async {
    var response = await RankApi.get(endpoint: '/comment/$commentId');

    return {
      'listId': response['listId'],
      'title': response['title'],
      'username': response['username'],
      'userId': response['userId'],
      'profilePic': response['profilePic']
    };
  }
}
