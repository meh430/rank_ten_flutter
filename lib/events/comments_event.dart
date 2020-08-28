import 'package:flutter/foundation.dart';

abstract class CommentEvent {}

class GetListCommentsEvent extends CommentEvent {
  final String listId;
  final int sort;
  final bool refresh;

  GetListCommentsEvent(
      {@required this.listId, this.sort = 0, this.refresh = false});
}

class GetUserCommentsEvent extends CommentEvent {
  final String token;
  final int sort;
  final bool refresh;

  GetUserCommentsEvent(
      {@required this.token, this.sort = 0, this.refresh = false});
}

class AddCommentEvent extends CommentEvent {
  final String token, listId, comment;

  AddCommentEvent(
      {@required this.token, @required this.listId, @required this.comment});
}

class UpdateCommentEvent extends CommentEvent {
  final String token, commentId, comment;

  UpdateCommentEvent(
      {@required this.token, @required this.commentId, @required this.comment});
}

class DeleteCommentEvent extends CommentEvent {
  final String token, commentId;

  DeleteCommentEvent({@required this.token, @required this.commentId});
}
