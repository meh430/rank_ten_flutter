import 'package:rank_ten/api/rank_exceptions.dart';
import 'package:rank_ten/api/response.dart';
import 'package:rank_ten/events/user_preview_events.dart';
import 'package:rank_ten/models/user.dart';
import 'package:rank_ten/repos/user_preview_repository.dart';

import 'bloc.dart';

class UserPreviewBloc extends Bloc<List<UserPreview>, UserPreviewEvent> {
  final String endpointBase;
  UserPreviewRepository _userPreviewRepository;

  Status currentStatus = Status.IDLE;

  //only for search for now
  int _currPage = 0;
  bool hitMax = false;

  UserPreviewBloc({this.endpointBase}) : super() {
    _userPreviewRepository = UserPreviewRepository();
    model = <UserPreview>[];
    initEventListener();
  }

  @override
  void eventToState(event) async {
    super.eventToState(event);
    if (event is UserPreviewEvent) {
      if (hitMax && !event.refresh) {
        return;
      }
      try {
        currentStatus = Status.LOADING;
        if (event.refresh) {
          _currPage = 1;
          model.clear();
        } else {
          _currPage += 1;
        }

        var pageContent = await _userPreviewRepository.getUserPreview(
            endpointBase: endpointBase,
            name: event.name,
            page: _currPage,
            sort: event.sort,
            query: event.query,
            refresh: event.refresh);

        if (endpointBase == SEARCH_USERS && pageContent.length < 100 ||
            endpointBase == FOLLOWERS_USERS ||
            endpointBase == FOLLOWING_USERS) {
          hitMax = true;
        }

        model.addAll(pageContent);
        currentStatus = Status.IDLE;
        try {
          modelStateSink.add(model);
        } catch (e) {
          print("Sink disposed?");
        }
      } on InvalidPageError {
        hitMax = true;
        _currPage -= 1;
        modelStateSink.add(model);
      }
    }
  }
}
