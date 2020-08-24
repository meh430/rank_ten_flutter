import 'package:flutter/material.dart';
import 'package:rank_ten/api/response.dart';
import 'package:rank_ten/blocs/user_bloc.dart';
import 'package:rank_ten/events/user_events.dart';
import 'package:rank_ten/models/user.dart';
import 'package:rank_ten/repos/user_repository.dart';

class MainUserProvider with ChangeNotifier {
  User mainUser;
  UserBloc mainUserBloc;
  String jwtToken;

  Stream<Response<User>> get mainUserState => mainUserBloc.userStateStream;

  Status currentStatus = Status.IDLE;

  Future<void> initMainUser(User user) async {
    mainUserBloc = UserBloc(isMain: true, mainUser: user);
    mainUser = user;
    mainUser.likedLists = await UserRepository()
        .getLikedListIds(name: mainUser.userName, token: jwtToken);
    print(mainUser.likedLists);
    print(mainUser.userName);
    mainUserState.listen((Response response) async {
      currentStatus = response.status;
      if (response.status == Status.COMPLETED) {
        mainUser = response.value;
        mainUser.likedLists = await UserRepository()
            .getLikedListIds(name: mainUser.userName, token: jwtToken);
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
