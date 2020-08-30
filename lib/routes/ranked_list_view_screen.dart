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
import 'package:rank_ten/models/ranked_list.dart';
import 'package:rank_ten/providers/dark_theme_provider.dart';
import 'package:rank_ten/providers/main_user_provider.dart';
import 'package:rank_ten/repos/user_preview_repository.dart';
import 'package:rank_ten/routes/ranked_list_edit_screen.dart';

class RankedListViewScreen extends StatefulWidget {
  final String listId, listTitle, profPic;
  final bool isMain, shouldPushInfo;

  RankedListViewScreen(
      {Key key,
      @required this.listId,
      @required this.listTitle,
      @required this.isMain,
      @required this.shouldPushInfo,
      @required this.profPic})
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
              if (snapshot.hasData) {
                List<Widget> listChildren = [];
                listChildren.add(Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: CardHeader(
                      shouldPushInfo: widget.shouldPushInfo,
                      userName: snapshot.data.userName,
                      profPicUrl: widget.profPic,
                      dateCreated: snapshot.data.dateCreated),
                ));
                snapshot.data.rankList
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
                            () => _rankedListBloc.modelEventSink
                                .add(GetRankedListEvent(widget.listId))),
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
              }

              return SpinKitRipple(size: 50, color: hanPurple);
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
                  onPressed: () =>
                      showListComments(context: context, listId: rankedList.id),
                ),
                GestureDetector(
                  onTap: () =>
                      showListComments(context: context, listId: rankedList.id),
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
  }
}

class RankedListViewScreenArgs {
  final String listId, listTitle, profPic;
  final bool isMain, shouldPushInfo;

  RankedListViewScreenArgs({@required this.profPic,
    @required this.shouldPushInfo,
    @required this.listId,
    @required this.listTitle,
    this.isMain = false});
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
                  padding:
                  EdgeInsets.only(bottom: 16, top: 8, left: 18, right: 16),
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
      isDismissible: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15), topLeft: Radius.circular(15))),
      context: context,
      builder: (BuildContext context) {
        return ListComments(listId: listId);
      });
}
