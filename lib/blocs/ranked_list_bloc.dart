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
    for (var rankItem in model.rankItems) {
      rankItem.private = model.private;
      rankItem.listTitle = model.title;
    }
  }

  @override
  void eventToState(event) async {
    super.eventToState(event);
    if (event is GetRankedListEvent) {
      model = event.listId != 0
          ? await _rankedListRepository.getRankedList(event.listId)
          : RankedList(rankItems: []);
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
      var rankItem = model.rankItems[event.index];
      rankItem.itemName = event.itemName;
      rankItem.description = event.description;
      rankItem.picture = event.picture;
      _updateParentProperties();
      modelStateSink.add(model);
    } else if (event is RankedListReorderEvent) {
      int oldIndex = event.previousPosition;
      int newIndex = event.newPosition;

      if (oldIndex < newIndex) {
        newIndex -= 1;
      }

      final RankItem rankItem = model.rankItems.removeAt(oldIndex);
      model.rankItems.insert(newIndex, rankItem);
      for (int i = 0; i < model.rankItems.length; i++) {
        model.rankItems[i].ranking = i + 1;
      }
      _updateParentProperties();

      modelStateSink.add(model);
    } else if (event is RankedListItemCreateEvent) {
      var rankItem = RankItem(
          private: model.private,
          listTitle: model.title,
          description: event.itemDescription,
          itemName: event.itemName,
          picture: event.imageUrl,
          ranking: model.rankItems.length + 1);

      model.rankItems.add(rankItem);
      _updateParentProperties();
      modelStateSink.add(model);
    } else if (event is RankedListItemDeleteEvent) {
      model.rankItems.removeAt(event.index);
      for (int i = 0; i < model.rankItems.length; i++) {
        model.rankItems[i].ranking = i + 1;
      }
      _updateParentProperties();
      modelStateSink.add(model);
    }
  }
}
