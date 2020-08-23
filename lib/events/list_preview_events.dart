abstract class ListPreviewEvent {}

abstract class SortedListPreviewEvent extends ListPreviewEvent {
  final int sort;

  SortedListPreviewEvent({this.sort});
}

class UserListsPreviewEvent extends SortedListPreviewEvent {
  UserListsPreviewEvent({int sort}) : super(sort: sort);
}

//TODO: add more events later
