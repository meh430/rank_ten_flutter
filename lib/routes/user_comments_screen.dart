import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/api/preferences_store.dart';
import 'package:rank_ten/blocs/comment_bloc.dart';
import 'package:rank_ten/components/comment_card.dart';
import 'package:rank_ten/events/comments_event.dart';
import 'package:rank_ten/misc/app_theme.dart';
import 'package:rank_ten/models/comment.dart';
import 'package:rank_ten/providers/dark_theme_provider.dart';
import 'package:rank_ten/providers/main_user_provider.dart';
import 'package:rank_ten/repos/comments_repository.dart';
import 'package:rank_ten/routes/ranked_list_view_screen.dart';

import 'main_screen.dart';

class UserCommentsScreen extends StatefulWidget {
  @override
  _UserCommentsScreenState createState() => _UserCommentsScreenState();
}

class _UserCommentsScreenState extends State<UserCommentsScreen> {
  int _sortOption = PreferencesStore.currentSort;
  CommentBloc _commentBloc;
  MainUserProvider _userProvider;
  ScrollController _scrollController;

  void _sortCallback(int option) {
    PreferencesStore.saveSort(option);
    _sortOption = option;
    print(option);
    _commentBloc.resetPage();
    _commentBloc.addEvent(
        GetUserCommentsEvent(sort: option, token: _userProvider.jwtToken));
  }

  void _onScrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!_commentBloc.hitMax) {
        _commentBloc.addEvent(GetUserCommentsEvent(
            sort: _sortOption, token: _userProvider.jwtToken));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController..addListener(_onScrollListener);
    _userProvider = Provider.of<MainUserProvider>(context, listen: false);

    _commentBloc = CommentBloc();
    _commentBloc.addEvent(GetUserCommentsEvent(token: _userProvider.jwtToken));
  }

  @override
  Widget build(BuildContext context) {
    var isDark = Provider.of<DarkThemeProvider>(context, listen: false).isDark;

    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          brightness: isDark ? Brightness.dark : Brightness.light,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [
            getSortAction(
                context: context, sortCallback: _sortCallback, isDark: isDark)
          ],
          title: Text("${_userProvider.mainUser.username}'s Comments",
              style: Theme.of(context).primaryTextTheme.headline5),
        ),
        body: StreamBuilder<List<Comment>>(
          stream: _commentBloc.modelStateStream,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(Duration(milliseconds: 0), () {
                    _commentBloc.addEvent(GetUserCommentsEvent(
                        sort: _sortOption,
                        token: _userProvider.jwtToken,
                        refresh: true));
                  });
                },
                child: ListView.builder(
                    shrinkWrap: false,
                    physics: const BouncingScrollPhysics(
                        parent: const AlwaysScrollableScrollPhysics()),
                    controller: _scrollController,
                    itemCount: snapshot.data.length + 1,
                    itemBuilder: (context, index) {
                      if (snapshot.data.length == 0) {
                        return Center(
                            child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  "You have not made any comments",
                                  style: Theme.of(context).textTheme.headline4,
                                  textAlign: TextAlign.center,
                                )));
                      }

                      if (index >= snapshot.data.length &&
                          !_commentBloc.hitMax) {
                        return Column(children: [
                          SizedBox(
                            height: 10,
                          ),
                          SpinKitWave(size: 50, color: hanPurple),
                          SizedBox(
                            height: 5,
                          )
                        ]);
                      } else if (index >= snapshot.data.length) {
                        return SizedBox();
                      }

                      return GestureDetector(
                        onTap: () async {
                          Map<String, dynamic> listCard =
                              await CommentsRepository().getCommentParent(
                                  commentId: snapshot.data[index].listId);
                          Navigator.pushNamed(context, '/ranked_list_view',
                              arguments: RankedListViewScreenArgs(
                                  listTitle: listCard['title'],
                                  listId: listCard['listId'],
                                  isMain: _userProvider.mainUser.userId ==
                                      listCard['userId'],
                                  shouldPushInfo:
                                      _userProvider.mainUser.userId ==
                                          listCard['userId'],
                                  profPic: ""));
                        },
                        child: CommentCard(
                          isMain: false,
                          key: ObjectKey(snapshot.data[index]),
                          comment: snapshot.data[index],
                        ),
                      );
                    }),
              );
            } else if (snapshot.hasError) {
              return Text("Error retrieving items...");
            }

            return SpinKitRipple(size: 50, color: hanPurple);
          },
        ));
  }
}
