import 'package:rank_ten/models/ranked_list.dart';

abstract class RankedListEvent {}

class GetRankedListEvent extends RankedListEvent {
  final String listId;

  GetRankedListEvent(this.listId);
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
