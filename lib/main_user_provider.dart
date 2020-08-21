import 'package:flutter/material.dart';
import 'package:rank_ten/api/response.dart';
import 'package:rank_ten/user_bloc.dart';
import 'package:rank_ten/user_events.dart';

import 'models/user.dart';

class MainUserProvider with ChangeNotifier {
  User mainUser;
  UserBloc mainUserBloc;
  String jwtToken;

  Stream<Response<User>> get mainUserState => mainUserBloc.userStateStream;

  Status currentStatus = Status.IDLE;

  void initMainUser(User user) {
    mainUserBloc = UserBloc(isMain: true, mainUser: user);
    mainUser = user;
    print(mainUser.userName);
    mainUserState.listen((Response response) {
      currentStatus = response.status;
      if (response.status == Status.COMPLETED) {
        mainUser = response.value;
        notifyListeners();
      }
    });
    notifyListeners();
  }

  void addUserEvent(UserEvent event) {
    mainUserBloc.userEventSink.add(event);
    notifyListeners();
  }

  void logOut() {
    mainUserBloc.dispose();
    mainUser = null;
    jwtToken = null;
  }
}
