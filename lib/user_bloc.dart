import 'dart:async';

import 'package:rank_ten/api/response.dart';
import 'package:rank_ten/user_events.dart';
import 'package:rank_ten/user_repository.dart';

import 'models/user.dart';

class UserBloc {
  User _user;

  UserRepository _userRepository;

  //stream the state
  StreamController _userStateController;

  StreamSink<Response<User>> get _userStateSink => _userStateController.sink;

  Stream<Response<User>> get userStateStream => _userStateController.stream;

  //add events
  StreamController _userEventController;

  StreamSink<UserEvent> get userEventSink => _userStateController.sink;

  UserBloc() {}
}
