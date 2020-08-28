import 'dart:async';

import 'package:rank_ten/events/comments_event.dart';
import 'package:rank_ten/models/comment.dart';
import 'package:rank_ten/repos/comments_repository.dart';

class CommentBloc {
  CommentsRepository _commentsRepository;

  StreamController _commentsStateController;

  StreamSink<List<Comment>> get _commentsStateSink =>
      _commentsStateController.sink;

  Stream<List<Comment>> get commentsStateStream =>
      _commentsStateController.stream;

  StreamController _commentsEventController;

  StreamSink<CommentEvent> get listEventSink => _commentsEventController.sink;
}
