import 'dart:async';

import 'package:rank_ten/api/rank_exceptions.dart';
import 'package:rank_ten/events/user_preview_events.dart';
import 'package:rank_ten/repos/user_preview_repository.dart';

abstract class Bloc<M, E> {
  M model;

  StreamController modelStateController;

  StreamSink<M> get modelStateSink => modelStateController.sink;

  Stream<M> get modelStateStream => modelStateController.stream;

  StreamController modelEventController;

  StreamSink<E> get modelEventSink => modelEventController.sink;

  int currentPage = -1;
  bool hitMax = false;

  void eventToState(dynamic event) async {}

  Bloc() {
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
      print(event.refresh);
      if (event.refresh) {
        currentPage = 0;
        (model as List).clear();
      } else {
        currentPage += 1;
      }
      print(currentPage);
      // {items, itemCount}
      var pageContent = await query(currentPage);

      if ((event is UserPreviewEvent &&
              endpointBase == SEARCH_USERS &&
              pageContent["lastPage"] == currentPage) ||
          (event is UserPreviewEvent) ||
          (pageContent["lastPage"] == currentPage)) {
        hitMax = true;
      }

      (model as List).addAll(pageContent["items"]);
      updateState();
    } on InvalidPageError {
      hitMax = true;
      currentPage = (currentPage < 0) ? -1 : (currentPage - 1);
      modelStateSink.add(model);
    }
  }

  void initEventListener() {
    modelEventController.stream.listen(eventToState);
  }

  void addEvent(E event) {
    modelEventSink.add(event);
  }

  void updateState() {
    try {
      modelStateSink.add(model);
    } catch (e) {
      print("Sink may have been disposed");
    }
  }

  void dispose() {
    modelStateController.close();
    modelEventController.close();
  }
}
