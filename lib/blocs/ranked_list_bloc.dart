import 'package:rank_ten/events/ranked_list_events.dart';
import 'package:rank_ten/models/ranked_list.dart';
import 'package:rank_ten/repos/ranked_list_repository.dart';

import 'bloc.dart';

class RankedListBloc extends Bloc<RankedList, RankedListEvent> {
  RankedListRepository _rankedListRepository;

  RankedListBloc() : super() {
    _rankedListRepository = RankedListRepository();
    initEventListener();
  }

  @override
  void eventToState(event) async {
    super.eventToState(event);
    if (event is GetRankedListEvent) {
      model = await _rankedListRepository.getRankedList(event.listId);
      modelStateSink.add(model);
    }
  }
}
