import 'package:rank_ten/events/ranked_list_preview_events.dart';
import 'package:rank_ten/models/ranked_list_card.dart';
import 'package:rank_ten/repos/ranked_list_preview_repository.dart';

import 'bloc.dart';

class PreviewListsBloc
    extends Bloc<List<RankedListCard>, RankedListPreviewEvent> {
  final String endpointBase;
  RankedListPreviewRepository _previewRepository;

  PreviewListsBloc({this.endpointBase}) {
    _previewRepository = RankedListPreviewRepository();
    model = [];

    initEventListener();
  }

  @override
  Future<void> eventToState(event) async {
    super.eventToState(event);
    if (event is RankedListPreviewEvent) {
      paginate(
          _previewRepository.getRankedListPreview(
              endpointBase: endpointBase,
              name: event.name,
              page: currentPage,
              sort: event.sort,
              token: event.token,
              query: event.query,
              refresh: event.refresh),
          event,
          nextQuery: _previewRepository.getRankedListPreview(
              endpointBase: endpointBase,
              name: event.name,
              page: currentPage + 1,
              sort: event.sort,
              token: event.token,
              query: event.query,
              refresh: event.refresh));
    }
  }
}
