import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/blocs/ranked_list_bloc.dart';
import 'package:rank_ten/components/list_comments.dart';
import 'package:rank_ten/components/rank_item_view_card.dart';
import 'package:rank_ten/components/user_preview_widget.dart';
import 'package:rank_ten/events/ranked_list_events.dart';
import 'package:rank_ten/misc/app_theme.dart';
import 'package:rank_ten/models/ranked_list.dart';
import 'package:rank_ten/providers/dark_theme_provider.dart';
import 'package:rank_ten/providers/main_user_provider.dart';
import 'package:rank_ten/repos/user_preview_repository.dart';

class RankedListViewScreen extends StatefulWidget {
  final String listId, listTitle;
  final bool isMain;

  RankedListViewScreen({Key key, this.listId, this.listTitle, this.isMain})
      : super(key: key);

  @override
  _RankedListViewScreenState createState() => _RankedListViewScreenState();
}

class _RankedListViewScreenState extends State<RankedListViewScreen> {
  RankedListBloc _rankedListBloc;

  @override
  void initState() {
    super.initState();
    _rankedListBloc = RankedListBloc();
    _rankedListBloc.modelEventSink.add(GetRankedListEvent(widget.listId));
  }

  @override
  Widget build(BuildContext context) {
    var isDark = Provider.of<DarkThemeProvider>(context).isDark;
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          brightness: isDark ? Brightness.dark : Brightness.light,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(widget.listTitle,
              style: Theme.of(context).primaryTextTheme.headline5),
        ),
        body: StreamBuilder<RankedList>(
            stream: _rankedListBloc.modelStateStream,
            builder:
                (BuildContext context, AsyncSnapshot<RankedList> snapshot) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => Future.delayed(
                            Duration(milliseconds: 0),
                            () => _rankedListBloc.modelEventSink
                                .add(GetRankedListEvent(widget.listId))),
                        child: ListView(
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            shrinkWrap: true,
                            children: snapshot.data.rankList
                                .map((rItem) => RankItemViewCard(
                                      rankItem: rItem,
                                    ))
                                .toList()),
                      ),
                    ),
                    RankListBottomBar(
                      rankedList: snapshot.data,
                    )
                  ],
                );
              }

              return SpinKitRipple(size: 50, color: hanPurple);
            }));
  }
}

class RankListBottomBar extends StatelessWidget {
  final RankedList rankedList;

  RankListBottomBar({Key key, this.rankedList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: LikeWidget(rankedList: rankedList),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.message),
                  onPressed: () =>
                      showListComments(context: context, listId: rankedList.id),
                ),
                GestureDetector(
                  onTap: () =>
                      showListComments(context: context, listId: rankedList.id),
                  child: Text(
                    "${rankedList.numComments} comments",
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline5,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class LikeWidget extends StatefulWidget {
  final RankedList rankedList;

  LikeWidget({Key key, this.rankedList}) : super(key: key);

  @override
  _LikeWidgetState createState() => _LikeWidgetState();
}

class _LikeWidgetState extends State<LikeWidget> {
  int _numLikes;
  bool _isLiked;
  Future<String> _likeFuture;
  MainUserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<MainUserProvider>(context, listen: false);
    _numLikes = widget.rankedList.numLikes;
    _isLiked = _userProvider.mainUser.likedLists.contains(widget.rankedList.id);
    _likeFuture = Future.delayed(Duration(milliseconds: 5), () => "INIT");
  }

  @override
  Widget build(BuildContext context) {
    var loading = Padding(
        padding: const EdgeInsets.all(15),
        child: SpinKitFoldingCube(size: 30, color: hanPurple));
    var userProvider = Provider.of<MainUserProvider>(context, listen: false);

    return FutureBuilder<String>(
        future: _likeFuture,
        key: UniqueKey(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool liked;
            if (snapshot.data == "INIT") {
              liked = _isLiked;
            } else if (snapshot.data == "LIKED") {
              liked = true;
              _numLikes += 1;
            } else if (snapshot.data == "UNLIKED") {
              liked = false;
              _numLikes -= 1;
            } else {
              return loading;
            }

            if (_numLikes < 0) {
              _numLikes = 0;
            }

            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  splashColor: Colors.transparent,
                  icon: Icon(liked ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _likeFuture = userProvider.likeList(widget.rankedList.id);
                    });
                  },
                ),
                GestureDetector(
                  onTap: () => showLikedUsers(
                      context: context, listId: widget.rankedList.id),
                  child: Text(
                    "$_numLikes likes",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                )
              ],
            );
          }

          return loading;
        });

    /*return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                splashColor: Colors.transparent,
                icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red, size: 55),
                onPressed: () async {
                  if (true) {
                    _liking = true;
                    var action;
                    try {
                      action = await widget.likePressed();
                    } catch (e) {
                      print(e);
                    }


                    if (action) {
                      setState(() {
                        _numLikes++;
                        _isLiked = true;
                      });
                    } else {
                      setState(() {
                        _numLikes--;
                        _isLiked = false;
                      });
                    }
                    //Future.delayed(
                    //    Duration(milliseconds: 1500), () => _liking = false);
                  } else {
                    Scaffold.of(context).hideCurrentSnackBar();
                    Scaffold.of(context)
                        .showSnackBar(Utils.getSB('Please wait'));
                  }
                },
              ),
              Column(children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "$_numLikes likes",
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline5,
                )
              ])
            ],
          ),
          SizedBox(height: 10)
        ],
      ),
    );*/
  }
}

class RankedListViewScreenArgs {
  final String listId, listTitle;
  final bool isMain;

  RankedListViewScreenArgs(
      {@required this.listId, @required this.listTitle, this.isMain = false});
}

void showLikedUsers({BuildContext context, String listId}) {
  showModalBottomSheet<void>(
    isDismissible: true,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(15), topLeft: Radius.circular(15))),
    context: context,
    builder: (BuildContext context) {
      return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Text("Liked By",
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline4)),
              Expanded(
                  child:
                  UserPreviewWidget(listType: LIKED_USERS, name: listId)),
            ],
          ));
    },
  );
}

void showListComments({BuildContext context, String listId}) {
  showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return ListComments(listId: listId);
      });
}
