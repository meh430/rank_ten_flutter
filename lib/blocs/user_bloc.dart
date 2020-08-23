import 'dart:async';

import 'package:rank_ten/api/response.dart';
import 'package:rank_ten/events/user_events.dart';
import 'package:rank_ten/models/user.dart';
import 'package:rank_ten/repos/user_repository.dart';

class UserBloc {
  User _user;

  UserRepository _userRepository;

  //stream the state
  StreamController _userStateController;

  StreamSink<Response<User>> get _userStateSink => _userStateController.sink;

  Stream<Response<User>> get userStateStream => _userStateController.stream;

  //add events
  StreamController _userEventController;

  StreamSink<UserEvent> get userEventSink => _userEventController.sink;

  UserBloc({String name, bool isMain = false, User mainUser}) {
    _userRepository = UserRepository();
    if (isMain) {
      _userStateController = StreamController<Response<User>>.broadcast();
    } else {
      _userStateController = StreamController<Response<User>>();
    }

    _userEventController = StreamController<UserEvent>();

    _userEventController.stream.listen(_eventToState);
    if (isMain) {
      _user = mainUser;
    } else {
      userEventSink.add(GetUserEvent(name));
    }
  }

  //update main user on relevant events
  void _eventToState(dynamic event) async {
    try {
      if (event is GetUserEvent) {
        _userStateSink.add(Response.loading("Loading user"));

        _user = await _userRepository.getUser(event.name);
        _userStateSink.add(Response.completed(_user));
      } else if (event is UpdateBioEvent) {
        _userStateSink.add(Response.loading("Updating bio"));

        await _userRepository.updateBio(bio: event.bio, token: event.token);

        _user.bio = event.bio;
        _userStateSink.add(Response.completed(_user));
      } else if (event is UpdateProfilePicEvent) {
        _userStateSink.add(Response.loading("Updating profile pic"));

        await _userRepository.updateProfilePic(
            profPic: event.profPic, token: event.token);

        _user.profPic = event.profPic;
        _userStateSink.add(Response.completed(_user));
      } else if (event is FollowEvent) {
        _userStateSink.add(Response.loading("Follow event"));

        final action = await _userRepository.followUser(
            name: event.name, token: event.token);
        if (action == "FOLLOW") {
          _user.numFollowers += 1;
        } else {
          _user.numFollowers -= 1;
        }

        _userStateSink.add(Response.completed(_user));
      }
    } catch (e) {
      _userStateSink.add(Response.error(e.toString()));
    }
  } //_evenToState

  void dispose() {
    _userEventController.close();
    _userStateController.close();
  }
}
