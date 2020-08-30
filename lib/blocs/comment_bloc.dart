import 'package:rank_ten/events/comments_event.dart';
import 'package:rank_ten/models/comment.dart';
import 'package:rank_ten/repos/comments_repository.dart';

import 'bloc.dart';

class CommentBloc extends Bloc<List<Comment>, CommentEvent> {
  CommentsRepository _commentsRepository;

  CommentBloc() : super() {
    model = [];
    _commentsRepository = CommentsRepository();
    initEventListener();
  }

  @override
  void eventToState(event) async {
    super.eventToState(event);
    if (event is GetListCommentsEvent) {
      await paginate(
          _commentsRepository.getListComments(
              listId: event.listId,
              page: currentPage,
              sort: event.sort,
              refresh: event.refresh),
          event);
    } else if (event is GetUserCommentsEvent) {
      await paginate(
          _commentsRepository.getUserComments(
              token: event.token,
              page: currentPage,
              sort: event.sort,
              refresh: event.refresh),
          event);
    } else if (event is AddCommentEvent) {
      var newComment = await _commentsRepository.addComment(
          listId: event.listId, token: event.token, comment: event.comment);
      model.add(newComment);
      updateState();
    } else if (event is UpdateCommentEvent) {
      var updatedComment = await _commentsRepository.updateComment(
          commentId: event.commentId,
          comment: event.comment,
          token: event.token);
      for (int i = 0; i < model.length; i++) {
        if (model[i].id == event.commentId) {
          model[i] = updatedComment;
          break;
        }
      }

      updateState();
    } else if (event is DeleteCommentEvent) {
      await _commentsRepository.deleteComment(
          commentId: event.commentId, token: event.token);
      for (int i = 0; i < model.length; i++) {
        if (model[i].id == event.commentId) {
          model.removeAt(i);
          break;
        }
      }

      updateState();
    }
  }
}
