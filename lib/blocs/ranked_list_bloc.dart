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

  void _updateParentProperties() {
    for (var rankItem in model.rankList) {
      rankItem.private = model.private;
      rankItem.parentTitle = model.title;
    }
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
      _updateParentProperties();
      modelStateSink.add(model);
    } else if (event is RankedListPrivateEvent) {
      model.private = event.private;
      _updateParentProperties();
      modelStateSink.add(model);
    } else if (event is RankedListItemUpdateEvent) {
      var rankItem = model.rankList[event.index];
      rankItem.itemName = event.itemName;
      rankItem.description = event.itemDescription;
      rankItem.picture = event.imageUrl;
      _updateParentProperties();
      modelStateSink.add(model);
    } else if (event is RankedListReorderEvent) {
      int oldIndex = event.previousPosition;
      int newIndex = event.newPosition;

      if (oldIndex < newIndex) {
        newIndex -= 1;
      }

      final RankItem rankItem = model.rankList.removeAt(oldIndex);
      model.rankList.insert(newIndex, rankItem);
      for (int i = 0; i < model.rankList.length; i++) {
        model.rankList[i].rank = i + 1;
      }
      _updateParentProperties();

      modelStateSink.add(model);
    } else if (event is RankedListItemCreateEvent) {
      var rankItem = RankItem(
          private: model.private,
          parentTitle: model.title,
          description: event.itemDescription,
          itemName: event.itemName,
          picture: event.imageUrl,
          rank: model.rankList.length + 1);

      model.rankList.add(rankItem);
      _updateParentProperties();
      modelStateSink.add(model);
    } else if (event is RankedListItemDeleteEvent) {
      model.rankList.removeAt(event.index);
      for (int i = 0; i < model.rankList.length; i++) {
        model.rankList[i].rank = i + 1;
      }
      _updateParentProperties();
      modelStateSink.add(model);
    }
  }
}
