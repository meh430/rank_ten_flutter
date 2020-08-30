import 'package:rank_ten/events/user_preview_events.dart';
import 'package:rank_ten/models/user.dart';
import 'package:rank_ten/repos/user_preview_repository.dart';

import 'bloc.dart';

class UserPreviewBloc extends Bloc<List<UserPreview>, UserPreviewEvent> {
  final String endpointBase;
  UserPreviewRepository _userPreviewRepository;

  UserPreviewBloc({this.endpointBase}) : super() {
    _userPreviewRepository = UserPreviewRepository();
    model = <UserPreview>[];
    initEventListener();
  }

  @override
  void eventToState(event) async {
    super.eventToState(event);
    if (event is UserPreviewEvent) {
      await paginate(
          _userPreviewRepository.getUserPreview(
              endpointBase: endpointBase,
              name: event.name,
              page: currentPage,
              sort: event.sort,
              query: event.query,
              refresh: event.refresh),
          event,
          endpointBase: endpointBase);
    }
  }
}
