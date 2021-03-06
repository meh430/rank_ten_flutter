import 'package:flutter/foundation.dart';
import 'package:rank_ten/models/ranked_list.dart';

abstract class RankedListEvent {}

class GetRankedListEvent extends RankedListEvent {
  final int listId;

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
  final String itemName, description, picture;

  RankedListItemUpdateEvent(
      {@required this.index,
      @required this.itemName,
      @required this.description,
      @required this.picture});
}

class RankedListItemDeleteEvent extends RankedListEvent {
  final int index;

  RankedListItemDeleteEvent(this.index);
}

class RankedListItemCreateEvent extends RankedListEvent {
  final String itemName, itemDescription, imageUrl;

  RankedListItemCreateEvent(
      {@required this.itemName, this.itemDescription = "", this.imageUrl = ""});
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
  final String token;
  final int listId;

  UpdateRankedListEvent(
      {@required this.rankedList, @required this.token, @required this.listId});
}

class DeleteRankedListEvent extends RankedListEvent {
  final String token;
  final int listId;

  DeleteRankedListEvent({@required this.token, @required this.listId});
}
