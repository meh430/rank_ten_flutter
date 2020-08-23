import 'dart:async';

import 'package:rank_ten/api/rank_exceptions.dart';
import 'package:rank_ten/api/response.dart';
import 'package:rank_ten/events/list_preview_events.dart';
import 'package:rank_ten/models/ranked_list_card.dart';
import 'package:rank_ten/repos/user_lists_repository.dart';

class UserListsBloc {
  final String name;
  int _currPage = 0;
  bool hitMax = false;
  List<RankedListCard> _userLists = [];
  UserListsRepository _userListsRepository;

  Status currentStatus = Status.IDLE;

  StreamController _userListsStateController;

  StreamSink<List<RankedListCard>> get _userListsStateSink =>
      _userListsStateController.sink;

  Stream<List<RankedListCard>> get userStateStream =>
      _userListsStateController.stream;

  StreamController _userListsEventController;

  StreamSink<UserListsPreviewEvent> get userListsEventSink =>
      _userListsEventController.sink;

  UserListsBloc({this.name}) {
    _userListsRepository = UserListsRepository();
    _userListsStateController = StreamController<List<RankedListCard>>();
    _userListsEventController = StreamController<UserListsPreviewEvent>();

    _userListsEventController.stream.listen(_eventToState);
  }

  void _eventToState(event) async {
    if (event is UserListsPreviewEvent) {
      if (hitMax) {
        return;
      }

      try {
        _currPage += 1;
        var pageContent = await _userListsRepository.getUserRankedLists(
            name: name, page: _currPage, sort: event.sort);
        _userLists.addAll(pageContent);
        _userListsStateSink.add(_userLists);
      } on InvalidPageError {
        hitMax = true;
        _currPage -= 1;
        _userListsStateSink.add(_userLists);
      }
    }
  }

  void dispose() {
    _userListsEventController.close();
    _userListsStateController.close();
  }
}
