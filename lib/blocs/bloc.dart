import 'dart:async';

abstract class Bloc<M, E> {
  M model;

  StreamController modelStateController;

  StreamSink<M> get modelStateSink => modelStateController.sink;

  Stream<M> get modelStateStream => modelStateController.stream;

  StreamController modelEventController;

  StreamSink<E> get modelEventSink => modelEventController.sink;

  void eventToState(dynamic event) async {}

  Bloc() {
    modelStateController = StreamController<M>();
    modelEventController = StreamController<E>();
  }

  void initEventListener() {
    modelEventController.stream.listen(eventToState);
  }

  void dispose() {
    modelStateController.close();
    modelEventController.close();
  }
}
