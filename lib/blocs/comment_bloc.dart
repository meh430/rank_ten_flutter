import 'package:rank_ten/api/rank_exceptions.dart';
import 'package:rank_ten/events/comments_event.dart';
import 'package:rank_ten/models/comment.dart';
import 'package:rank_ten/repos/comments_repository.dart';

import 'bloc.dart';

class CommentBloc extends Bloc<List<Comment>, CommentEvent> {
  CommentsRepository _commentsRepository;

  int _currPage = 0;
  bool hitMax = false;

  CommentBloc() : super() {
    model = [];
    _commentsRepository = CommentsRepository();
    initEventListener();
  }

  @override
  void eventToState(event) async {
    super.eventToState(event);
    if (event is GetListCommentsEvent) {
      if (hitMax && !event.refresh) {
        return;
      }

      try {
        if (event.refresh) {
          _currPage = 1;
          model.clear();
        } else {
          _currPage += 1;
        }

        var pageContent = await _commentsRepository.getListComments(
            listId: event.listId,
            page: _currPage,
            sort: event.sort,
            refresh: event.refresh);

        if (pageContent.length < 10) {
          hitMax = true;
        }

        model.addAll(pageContent);
        updateState();
      } on InvalidPageError {
        hitMax = true;
        _currPage -= 1;
        modelStateSink.add(model);
      }
    } else if (event is GetUserCommentsEvent) {
      if (hitMax && !event.refresh) {
        return;
      }

      try {
        if (event.refresh) {
          _currPage = 1;
          model.clear();
        } else {
          _currPage += 1;
        }

        var pageContent = await _commentsRepository.getUserComments(
            token: event.token,
            page: _currPage,
            sort: event.sort,
            refresh: event.refresh);

        if (pageContent.length < 10) {
          hitMax = true;
        }

        model.addAll(pageContent);
        updateState();
      } on InvalidPageError {
        hitMax = true;
        _currPage -= 1;
        modelStateSink.add(model);
      }
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
