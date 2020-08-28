import 'dart:async';

abstract class Bloc<M, E> {
  M model;

  StreamController _modelStateController;

  StreamSink<M> get modelStateSink => _modelStateController.sink;

  Stream<M> get modelStateStream => _modelStateController.stream;

  StreamController _modelEventController;

  StreamSink<E> get modelEventSink => _modelEventController.sink;

  void eventToState(dynamic event) async {}

  Bloc() {
    _modelStateController = StreamController<M>();
    _modelEventController = StreamController<E>();
  }

  void initEventListener() {
    _modelEventController.stream.listen(eventToState);
  }

  void dispose() {
    _modelStateController.close();
    _modelEventController.close();
  }
}
