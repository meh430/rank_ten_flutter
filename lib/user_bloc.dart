import 'dart:async';

import 'package:rank_ten/api/response.dart';
import 'package:rank_ten/app.dart';
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

  UserBloc(String name) {
    _userRepository = UserRepository();
    _userStateController = StreamController<Response<User>>();
    _userEventController = StreamController<UserEvent>();

    _userEventController.stream.listen(_eventToState);
  }

  void _eventToState(UserEvent event) async {
    try {
      if (event is GetUserEvent) {
        _userStateSink.add(Response.loading("Loading user"));

        _user = await _userRepository.getUser(event.name);
        _userStateSink.add(Response.completed(_user));
      } else if (event is UpdateBioEvent) {
        _userStateSink.add(Response.loading("Updating bio"));

        await _userRepository.updateBio(event.bio);

        _user.bio = event.bio;
        _userStateSink.add(Response.completed(_user));
      } else if (event is UpdateProfilePicEvent) {
        _userStateSink.add(Response.loading("Updating profile pic"));

        await _userRepository.updateProfilePic(event.profPic);

        _user.profPic = event.profPic;
        _userStateSink.add(Response.completed(_user));
      } else if (event is FollowEvent) {
        _userStateSink.add(Response.loading("Follow event"));

        final action = await _userRepository.followUser(event.name);
        if (action == "FOLLOW") {
          _user.numFollowers += 1;
          mainUser.numFollowing += 1;
        } else {
          _user.numFollowers -= 1;
          mainUser.numFollowing -= 1;
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
