import 'package:flutter/material.dart';
import 'package:rank_ten/api/preferences_store.dart';
import 'package:rank_ten/api/response.dart';
import 'package:rank_ten/blocs/user_bloc.dart';
import 'package:rank_ten/events/user_events.dart';
import 'package:rank_ten/models/user.dart';
import 'package:rank_ten/repos/user_repository.dart';

class MainUserProvider with ChangeNotifier {
  User mainUser;
  UserBloc mainUserBloc;
  String jwtToken;
  UserRepository _userRepository;

  Stream<Response<User>> get mainUserState => mainUserBloc.userStateStream;

  void initMainUser(User user) {
    mainUserBloc = UserBloc(isMain: true, mainUser: user);
    mainUser = user;
    _userRepository = UserRepository();
    //mainUser.likedLists = await UserRepository()
    //    .getLikedListIds(name: mainUser.userName, token: jwtToken);

    mainUserState.listen((Response response) {
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

  Future<LikeResponse> likeComment(int commentId) async {
    LikeResponse action = await _userRepository.likeComment(
        commentId: commentId, token: jwtToken);

    if (mainUser.likedComments.contains(commentId)) {
      mainUser.likedComments.remove(commentId);
    } else {
      mainUser.likedComments.add(commentId);
    }
    return action;
  }

  Future<LikeResponse> likeList(int listId) async {
    LikeResponse action =
        await _userRepository.likeList(listId: listId, token: jwtToken);

    if (mainUser.likedLists.contains(listId)) {
      mainUser.likedLists.remove(listId);
    } else {
      mainUser.likedLists.add(listId);
    }

    return action;
  }

  Future<FollowResponse> followUser({@required int userId}) async {
    var action =
        await UserRepository().followUser(userId: userId, token: jwtToken);
    if (mainUser.following.contains(userId)) {
      mainUser.following.remove(userId);
    } else {
      mainUser.following.add(userId);
    }
    return action;
  }

  void logOut() {
    mainUserBloc.dispose();
    PreferencesStore.clearAll();
    mainUser = null;
    jwtToken = null;
  }
}
