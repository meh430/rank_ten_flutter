import 'dart:async';

import 'package:rank_ten/events/ranked_list_events.dart';
import 'package:rank_ten/models/ranked_list.dart';
import 'package:rank_ten/repos/ranked_list_repository.dart';

class RankedListBloc {
  RankedListRepository _rankedListRepository;

  RankedList _rankedList;

  StreamController _rankedListStateController;

  Stream<RankedList> get rankedListStateStream =>
      _rankedListStateController.stream;

  StreamSink<RankedList> get _rankedListStateSink =>
      _rankedListStateController.sink;

  StreamController _rankedListEventController;

  StreamSink<RankedListEvent> get rankedListEventSink =>
      _rankedListEventController.sink;

  RankedListBloc() {
    _rankedListRepository = RankedListRepository();
    _rankedListStateController = StreamController<RankedList>();
    _rankedListEventController = StreamController<RankedListEvent>();

    _rankedListEventController.stream.listen(_eventToState);
  }

  void _eventToState(dynamic event) async {
    if (event is GetRankedListEvent) {
      _rankedList = await _rankedListRepository.getRankedList(event.listId);
      _rankedListStateSink.add(_rankedList);
    }
  }

  void dispose() {
    _rankedListEventController.close();
    _rankedListStateController.close();
  }
}
