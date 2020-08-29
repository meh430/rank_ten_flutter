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
      this.index, this.itemName, this.itemDescription, this.imageUrl);
}

class RankedListReorderEvent extends RankedListEvent {
  final int previousPosition, newPosition;

  RankedListReorderEvent(this.previousPosition, this.newPosition);
}

class CreateRankedListEvent extends RankedListEvent {
  final RankedList rankedList;
  final String token;

  CreateRankedListEvent(this.rankedList, this.token);
}

class UpdateRankedListEvent extends RankedListEvent {
  final RankedList rankedList;
  final String token, listId;

  UpdateRankedListEvent(this.rankedList, this.token, this.listId);
}

class DeleteRankedListEvent extends RankedListEvent {
  final String token, listId;

  DeleteRankedListEvent(this.token, this.listId);
}
