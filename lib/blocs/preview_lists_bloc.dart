import 'dart:async';

import 'package:rank_ten/api/rank_exceptions.dart';
import 'package:rank_ten/api/response.dart';
import 'package:rank_ten/events/ranked_list_preview_events.dart';
import 'package:rank_ten/models/ranked_list_card.dart';
import 'package:rank_ten/repos/ranked_list_preview_repository.dart';

class PreviewListsBloc {
  final String endpointBase;

  int _currPage = 0;
  bool hitMax = false;
  List<RankedListCard> _previewLists = [];
  RankedListPreviewRepository _previewRepository;

  Status currentStatus = Status.IDLE;

  StreamController _listStateController;

  StreamSink<List<RankedListCard>> get _listStateSink =>
      _listStateController.sink;

  Stream<List<RankedListCard>> get listStateStream =>
      _listStateController.stream;

  StreamController _listEventController;

  StreamSink<RankedListPreviewEvent> get listEventSink =>
      _listEventController.sink;

  PreviewListsBloc({this.endpointBase}) {
    _previewRepository = RankedListPreviewRepository();
    _listStateController = StreamController<List<RankedListCard>>();
    _listEventController = StreamController<RankedListPreviewEvent>();

    _listEventController.stream.listen(_eventToState);
  }

  void _eventToState(event) async {
    if (event is RankedListPreviewEvent) {
      if (hitMax) {
        return;
      }

      try {
        currentStatus = Status.LOADING;
        if (event.refresh) {
          _currPage = 1;
          _previewLists.clear();
        } else {
          _currPage += 1;
        }

        var pageContent = await _previewRepository.getRankedListPreview(
            endpointBase: endpointBase,
            name: event.name,
            page: _currPage,
            sort: event.sort,
            token: event.token,
            query: event.query,
            refresh: event.refresh);

        if (pageContent.length < 10) {
          hitMax = true;
        }

        _previewLists.addAll(pageContent);
        currentStatus = Status.IDLE;
        _listStateSink.add(_previewLists);
      } on InvalidPageError {
        hitMax = true;
        _currPage -= 1;
        _listStateSink.add(_previewLists);
      }
    }
  }

  void dispose() {
    _listEventController.close();
    _listStateController.close();
  }
}
