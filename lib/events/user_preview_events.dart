import 'package:rank_ten/events/ranked_list_preview_events.dart';

class UserPreviewEvent extends RankedListPreviewEvent {
  UserPreviewEvent(
      {int sort = 0, String name = "", String query = "", bool refresh = false})
      : super(name: name, sort: sort, query: query, refresh: refresh);
}
