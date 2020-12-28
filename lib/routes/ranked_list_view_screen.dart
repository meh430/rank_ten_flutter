import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/blocs/ranked_list_bloc.dart';
import 'package:rank_ten/components/list_comments.dart';
import 'package:rank_ten/components/rank_item_view_card.dart';
import 'package:rank_ten/components/ranked_list_card_widget.dart';
import 'package:rank_ten/components/user_preview_widget.dart';
import 'package:rank_ten/events/ranked_list_events.dart';
import 'package:rank_ten/misc/app_theme.dart';
import 'package:rank_ten/misc/utils.dart';
import 'package:rank_ten/models/ranked_list.dart';
import 'package:rank_ten/providers/dark_theme_provider.dart';
import 'package:rank_ten/providers/main_user_provider.dart';
import 'package:rank_ten/repos/user_preview_repository.dart';
import 'package:rank_ten/repos/user_repository.dart';
import 'package:rank_ten/routes/ranked_list_edit_screen.dart';

class RankedListViewScreen extends StatefulWidget {
  final String listTitle, profilePic;
  final bool isMain, shouldPushInfo;
  final int listId;

  RankedListViewScreen(
      {Key key,
      @required this.listId,
      @required this.listTitle,
      @required this.isMain,
      @required this.shouldPushInfo,
      @required this.profilePic})
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
    _rankedListBloc.addEvent(GetRankedListEvent(widget.listId));
  }

  @override
  Widget build(BuildContext context) {
    var isDark = Provider.of<DarkThemeProvider>(context).isDark;
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          brightness: isDark ? Brightness.dark : Brightness.light,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [
            widget.isMain
                ? IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/ranked_list_edit',
                          arguments: RankedListEditScreenArgs(
                              listId: widget.listId,
                              listTitle: widget.listTitle,
                              isNew: false));
                    },
                    icon: Icon(Icons.edit))
                : SizedBox()
          ],
          title: Text(widget.listTitle,
              style: Theme.of(context).primaryTextTheme.headline5),
        ),
        body: StreamBuilder<RankedList>(
            stream: _rankedListBloc.modelStateStream,
            builder:
                (BuildContext context, AsyncSnapshot<RankedList> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                List<Widget> listChildren = [];
                listChildren.add(Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: CardHeader(
                      userId: snapshot.data.userId,
                      shouldPushInfo: widget.shouldPushInfo,
                      userName: snapshot.data.username,
                      profPicUrl: widget.profilePic,
                      dateCreated: snapshot.data.dateCreated),
                ));
                snapshot.data.rankItems
                    .forEach((rItem) => listChildren.add(RankItemViewCard(
                          rankItem: rItem,
                        )));
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => Future.delayed(
                            Duration(milliseconds: 0),
                            () => _rankedListBloc
                                .addEvent(GetRankedListEvent(widget.listId))),
                        child: ListView(
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            shrinkWrap: true,
                            children: listChildren),
                      ),
                    ),
                    RankListBottomBar(
                      rankedList: snapshot.data,
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                WidgetsBinding.instance.addPostFrameCallback(
                    (_) => Utils.showSB("Error getting list", context));
                return Utils.getErrorImage();
              }

              return const SpinKitRipple(size: 50, color: hanPurple);
            }));
  }
}

class RankListBottomBar extends StatelessWidget {
  final RankedList rankedList;
  final bool editing;
  final VoidCallback onAdded;

  RankListBottomBar(
      {Key key, this.rankedList, this.editing = false, this.onAdded})
      : super(key: key);

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
          editing
              ? RaisedButton(
                  padding: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  color: paraPink,
                  onPressed: onAdded,
                  child: Icon(Icons.add, color: palePurple),
                )
              : SizedBox(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.message),
                  onPressed: () => showListComments(
                      context: context, listId: rankedList.listId),
                ),
                GestureDetector(
                  onTap: () => showListComments(
                      context: context, listId: rankedList.listId),
                  child: Text(
                    "${rankedList.numComments} comments",
                    style: Theme.of(context).textTheme.headline5,
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
  Future<LikeResponse> _likeFuture;
  MainUserProvider _userProvider;
  bool _isLiked, _error;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<MainUserProvider>(context, listen: false);
    _numLikes = widget.rankedList.numLikes;
    _likeFuture =
        Future.delayed(Duration(milliseconds: 5), () => LikeResponse.init);
    _isLiked =
        _userProvider.mainUser.likedLists.contains(widget.rankedList.listId);
    _error = false;
  }

  @override
  Widget build(BuildContext context) {
    var loading = Padding(
        padding: const EdgeInsets.all(15),
        child: const SpinKitFoldingCube(size: 30, color: hanPurple));

    return FutureBuilder<LikeResponse>(
        future: _likeFuture,
        key: UniqueKey(),
        builder: (context, snapshot) {
          _error = false;
          if (snapshot.hasData) {
            bool liked;
            if (snapshot.data == LikeResponse.init) {
              liked = _isLiked;
            } else if (snapshot.data == LikeResponse.liked) {
              liked = true;
              _numLikes += 1;
            } else if (snapshot.data == LikeResponse.unliked) {
              liked = false;
              _numLikes -= 1;
            } else if (snapshot.data == LikeResponse.error) {
              liked = _isLiked;
              _error = true;
            } else {
              return loading;
            }

            _isLiked = liked;

            _likeFuture = Future.delayed(
                Duration(milliseconds: 5), () => LikeResponse.init);

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
                      _likeFuture =
                          _userProvider.likeList(widget.rankedList.listId);
                    });
                  },
                ),
                GestureDetector(
                  onTap: () => showLikedUsers(
                      context: context, listId: widget.rankedList.listId),
                  child: Text(
                    _error ? "Try Again" : "$_numLikes likes",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                )
              ],
            );
          }

          return loading;
        });
  }
}

class RankedListViewScreenArgs {
  final String listTitle, profilePic;
  final bool isMain, shouldPushInfo;
  final int listId;

  RankedListViewScreenArgs(
      {@required this.profilePic,
      @required this.shouldPushInfo,
      @required this.listId,
      @required this.listTitle,
      this.isMain = false});
}

void showLikedUsers({BuildContext context, int listId}) {
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
                  padding:
                      EdgeInsets.only(bottom: 16, top: 8, left: 18, right: 16),
                  child: Text("Liked By",
                      style: Theme.of(context).textTheme.headline5)),
              Expanded(
                  child: UserPreviewWidget(listType: LIKED_USERS, id: listId)),
            ],
          ));
    },
  );
}

void showListComments({BuildContext context, int listId}) {
  showModalBottomSheet<void>(
      isDismissible: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15), topLeft: Radius.circular(15))),
      context: context,
      builder: (BuildContext context) {
        return ListComments(listId: listId);
      });
}
