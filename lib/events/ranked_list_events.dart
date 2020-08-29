import 'package:flutter/foundation.dart';
import 'package:rank_ten/models/ranked_list.dart';

abstract class RankedListEvent {}

class GetRankedListEvent extends RankedListEvent {
  final String listId;

  GetRankedListEvent(this.listId);
}

class RankedListTitleEvent extends RankedListEvent {
  final String title;

  RankedListTitleEvent(this.title);
}

class RankedListPrivateEvent extends RankedListEvent {
  final bool private;

  RankedListPrivateEvent(this.private);
}

class RankedListItemUpdateEvent extends RankedListEvent {
  final int index;
  final String itemName, itemDescription, imageUrl;

  RankedListItemUpdateEvent(
      {@required this.index,
      @required this.itemName,
      @required this.itemDescription,
      @required this.imageUrl});
}

class RankedListReorderEvent extends RankedListEvent {
  final int previousPosition, newPosition;

  RankedListReorderEvent(
      {@required this.previousPosition, @required this.newPosition});
}

class CreateRankedListEvent extends RankedListEvent {
  final RankedList rankedList;
  final String token;

  CreateRankedListEvent({@required this.rankedList, @required this.token});
}

class UpdateRankedListEvent extends RankedListEvent {
  final RankedList rankedList;
  final String token, listId;

  UpdateRankedListEvent(
      {@required this.rankedList, @required this.token, @required this.listId});
}

class DeleteRankedListEvent extends RankedListEvent {
  final String token, listId;

  DeleteRankedListEvent({@required this.token, @required this.listId});
}
