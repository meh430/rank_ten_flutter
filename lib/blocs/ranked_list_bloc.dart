import 'package:rank_ten/events/ranked_list_events.dart';
import 'package:rank_ten/models/rank_item.dart';
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
      model = event.listId != null && event.listId.isNotEmpty
          ? await _rankedListRepository.getRankedList(event.listId)
          : RankedList(rankList: []);
      modelStateSink.add(model);
    } else if (event is RankedListTitleEvent) {
      model.title = event.title;
      modelStateSink.add(model);
    } else if (event is RankedListPrivateEvent) {
      model.private = event.private;
      for (var rankItem in model.rankList) {
        rankItem.private = event.private;
      }
      modelStateSink.add(model);
    } else if (event is RankedListItemUpdateEvent) {
      var rankItem = model.rankList[event.index];
      rankItem.itemName = event.itemName;
      rankItem.description = event.itemDescription;
      rankItem.picture = event.imageUrl;

      modelStateSink.add(model);
    } else if (event is RankedListReorderEvent) {
      int oldIndex = event.previousPosition;
      int newIndex = event.newPosition;

      if (oldIndex < newIndex) {
        newIndex -= 1;
      }

      final RankItem rankItem = model.rankList.removeAt(oldIndex);
      model.rankList.insert(newIndex, rankItem);

      modelStateSink.add(model);
    }
  }
}
