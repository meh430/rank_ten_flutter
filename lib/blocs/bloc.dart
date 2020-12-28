import 'dart:async';

import 'package:rank_ten/api/rank_exceptions.dart';
import 'package:rank_ten/events/user_preview_events.dart';
import 'package:rank_ten/repos/user_preview_repository.dart';

abstract class Bloc<M, E> {
  M model;
  bool _isDisposed = false;

  StreamController modelStateController;

  StreamSink<M> get modelStateSink => modelStateController.sink;

  Stream<M> get modelStateStream => modelStateController.stream;

  StreamController modelEventController;

  StreamSink<E> get modelEventSink => modelEventController.sink;

  int currentPage = -1;
  bool hitMax = false;

  void eventToState(dynamic event) async {}

  Bloc() {
    _isDisposed = false;
    modelStateController = StreamController<M>();
    modelEventController = StreamController<E>();
  }

  // query is the network callback
  void paginate(dynamic query, dynamic event,
      {String endpointBase = ""}) async {
    if (hitMax && !event.refresh) {
      return;
    }

    try {
      if (event.refresh) {
        currentPage = 0;
        (model as List).clear();
      } else {
        currentPage += 1;
      }
      // {items, itemCount}
      var pageContent = await query(currentPage);

      if ((event is UserPreviewEvent &&
              endpointBase == SEARCH_USERS &&
              pageContent["lastPage"] == currentPage) ||
          (event is UserPreviewEvent) ||
          (pageContent["lastPage"] == currentPage)) {
        hitMax = true;
      }

      (model as List).addAll(
          (event is UserPreviewEvent && endpointBase != SEARCH_USERS)
              ? pageContent
              : pageContent["items"]);
      updateState();
    } on InvalidPageError {
      hitMax = true;
      currentPage = (currentPage < 0) ? -1 : (currentPage - 1);
      modelStateSink.add(model);
    } catch (e) {
      modelStateSink.addError(e);
    }
  }

  void initEventListener() {
    modelEventController.stream.listen(eventToState);
  }

  void addEvent(E event) {
    if (_isDisposed) {
      return;
    }
    modelEventSink.add(event);
  }

  void updateState() {
    if (_isDisposed) {
      return;
    }
    try {
      modelStateSink.add(model);
    } catch (e) {
      print(e);
    }
  }

  void dispose() {
    _isDisposed = true;
    modelStateController.close();
    modelEventController.close();
  }
}
