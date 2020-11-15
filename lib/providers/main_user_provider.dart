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

  Future<void> initMainUser(User user) async {
    mainUserBloc = UserBloc(isMain: true, mainUser: user);
    mainUser = user;
    //mainUser.likedLists = await UserRepository()
    //    .getLikedListIds(name: mainUser.userName, token: jwtToken);

    mainUserState.listen((Response response) async {
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

  Future<String> likeComment(String commentId) async {
    String action = await UserRepository()
        .likeComment(commentId: commentId, token: jwtToken);

    return action;
  }

  Future<String> likeList(String listId) async {
    String action =
        await UserRepository().likeList(listId: listId, token: jwtToken);

    if (mainUser.likedLists.contains(listId)) {
      mainUser.likedLists.remove(listId);
    } else {
      mainUser.likedLists.add(listId);
    }

    return action;
  }

  Future<String> followUser({String name, String userId}) async {
    var action = await UserRepository().followUser(name: name, token: jwtToken);
    if (mainUser.following.contains(userId)) {
      mainUser.following.remove(userId);
    } else {
      mainUser.following.add(userId);
    }
    return action;
  }

  void logOut() {
    mainUserBloc.dispose();
    mainUser = null;
    jwtToken = null;
  }
}
