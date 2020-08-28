import 'package:rank_ten/events/comments_event.dart';
import 'package:rank_ten/models/comment.dart';
import 'package:rank_ten/repos/comments_repository.dart';

import 'bloc.dart';

class CommentBloc extends Bloc<List<Comment>, CommentEvent> {
  CommentsRepository _commentsRepository;

  CommentBloc() : super() {
    _commentsRepository = CommentsRepository();
  }

  @override
  void eventToState(event) async {
    super.eventToState(event);
  }
}
