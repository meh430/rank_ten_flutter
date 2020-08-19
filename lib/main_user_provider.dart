import 'package:flutter/material.dart';
import 'package:rank_ten/api/response.dart';
import 'package:rank_ten/user_bloc.dart';
import 'package:rank_ten/user_events.dart';

import 'models/user.dart';

class MainUserProvider with ChangeNotifier {
  User mainUser;
  UserBloc mainUserBloc;

  Stream<Response<User>> get mainUserState => mainUserBloc.userStateStream;

  Status currentStatus = Status.IDLE;

  void initMainUser(String name) async {
    mainUserBloc = UserBloc(name);
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
}
