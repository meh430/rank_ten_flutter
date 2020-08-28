import 'package:rank_ten/api/rank_exceptions.dart';
import 'package:rank_ten/api/response.dart';
import 'package:rank_ten/events/ranked_list_preview_events.dart';
import 'package:rank_ten/models/ranked_list_card.dart';
import 'package:rank_ten/repos/ranked_list_preview_repository.dart';

import 'bloc.dart';

class PreviewListsBloc
    extends Bloc<List<RankedListCard>, RankedListPreviewEvent> {
  final String endpointBase;

  int _currPage = 0;
  bool hitMax = false;
  RankedListPreviewRepository _previewRepository;

  Status currentStatus = Status.IDLE;

  PreviewListsBloc({this.endpointBase}) {
    _previewRepository = RankedListPreviewRepository();
    model = [];

    initEventListener();
  }

  @override
  Future<void> eventToState(event) async {
    super.eventToState(event);
    if (event is RankedListPreviewEvent) {
      if (hitMax && !event.refresh) {
        return;
      }

      try {
        currentStatus = Status.LOADING;
        if (event.refresh) {
          _currPage = 1;
          model.clear();
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

        model.addAll(pageContent);
        currentStatus = Status.IDLE;
        updateState();
      } on InvalidPageError {
        hitMax = true;
        _currPage -= 1;
        modelStateSink.add(model);
      }
    }
  }
}
