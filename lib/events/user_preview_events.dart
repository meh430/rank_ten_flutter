import 'package:rank_ten/events/ranked_list_preview_events.dart';

class UserPreviewEvent extends RankedListPreviewEvent {
  UserPreviewEvent(
      {int sort = 0, int id = 1, String query = "", bool refresh = false})
      : super(userId: id, sort: sort, query: query, refresh: refresh);
}
