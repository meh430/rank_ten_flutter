abstract class RankedListEvent {}

class GetRankedListEvent extends RankedListEvent {
  final String listId;

  GetRankedListEvent(this.listId);
}
