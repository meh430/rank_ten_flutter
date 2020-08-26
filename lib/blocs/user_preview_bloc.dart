import 'dart:async';

import 'package:rank_ten/api/rank_exceptions.dart';
import 'package:rank_ten/api/response.dart';
import 'package:rank_ten/events/user_preview_events.dart';
import 'package:rank_ten/models/user.dart';
import 'package:rank_ten/repos/user_preview_repository.dart';

class UserPreviewBloc {
  final String endpointBase;

  //only for search for now
  int _currPage = 0;
  bool hitMax = false;

  List<UserPreview> _userPreviews = [];
  UserPreviewRepository _userPreviewRepository;

  Status currentStatus = Status.IDLE;

  StreamController _userPreviewStateController;

  StreamSink<List<UserPreview>> get _userPreviewStateSink =>
      _userPreviewStateController.sink;

  Stream<List<UserPreview>> get userPreviewStateStream =>
      _userPreviewStateController.stream;

  StreamController _userPreviewEventController;

  StreamSink<UserPreviewEvent> get userPreviewEventSink =>
      _userPreviewEventController.sink;

  UserPreviewBloc({this.endpointBase}) {
    _userPreviewRepository = UserPreviewRepository();
    _userPreviewStateController = StreamController<List<UserPreview>>();
    _userPreviewEventController = StreamController<UserPreviewEvent>();

    _userPreviewEventController.stream.listen(_eventToState);
  }

  void _eventToState(event) async {
    if (event is UserPreviewEvent) {
      if (hitMax && !event.refresh) {
        return;
      }
      try {
        currentStatus = Status.LOADING;
        if (event.refresh) {
          _currPage = 1;
          _userPreviews.clear();
        } else {
          _currPage += 1;
        }

        var pageContent = await _userPreviewRepository.getUserPreview(
            endpointBase: endpointBase,
            name: event.name,
            page: _currPage,
            sort: event.sort,
            query: event.query,
            refresh: event.refresh);

        if (endpointBase == SEARCH_USERS && pageContent.length < 100 ||
            endpointBase == FOLLOWERS_USERS ||
            endpointBase == FOLLOWING_USERS) {
          hitMax = true;
        }

        _userPreviews.addAll(pageContent);
        currentStatus = Status.IDLE;
        try {
          _userPreviewStateSink.add(_userPreviews);
        } catch (e) {
          print("Sink disposed?");
        }
      } on InvalidPageError {
        hitMax = true;
        _currPage -= 1;
        _userPreviewStateSink.add(_userPreviews);
      }
    }
  }

  void dispose() {
    _userPreviewEventController.close();
    _userPreviewStateController.close();
  }
}
