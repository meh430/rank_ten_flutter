import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/components/rank_item_view_card.dart';
import 'package:rank_ten/misc/app_theme.dart';
import 'package:rank_ten/misc/utils.dart';
import 'package:rank_ten/models/ranked_list_card.dart';
import 'package:rank_ten/providers/dark_theme_provider.dart';
import 'package:rank_ten/providers/main_user_provider.dart';
import 'package:rank_ten/repos/user_repository.dart';
import 'package:rank_ten/routes/ranked_list_view_screen.dart';
import 'package:rank_ten/routes/user_info_screen.dart';

import 'choose_pic.dart';

void launchRankListViewScreen({
  @required BuildContext context,
  @required RankedListCard listCard,
  @required bool shouldPushInfo,
}) {
  var userProvider =
      Provider.of<MainUserProvider>(context, listen: false).mainUser;
  Navigator.pushNamed(context, '/ranked_list_view',
      arguments: RankedListViewScreenArgs(
          listTitle: listCard.title,
          listId: listCard.listId,
          isMain: userProvider.userId == listCard.userId,
          shouldPushInfo: shouldPushInfo,
          profPic: listCard.profilePic));
}

class RankedListCardWidget extends StatelessWidget {
  final RankedListCard listCard;
  final bool shouldPushInfo;

  const RankedListCardWidget(
      {Key key, @required this.listCard, this.shouldPushInfo = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<MainUserProvider>(context, listen: false);
    var isLiked = userProvider.mainUser.likedLists.contains(listCard.listId);

    var hasThree = listCard.numItems > 3;
    var remainingLabel = "";
    if (hasThree && listCard.numItems == 4) {
      remainingLabel = "View 1 more item";
    } else if (hasThree) {
      remainingLabel = "View ${listCard.numItems - 3} more items";
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CardHeader(
                shouldPushInfo: shouldPushInfo,
                userId: listCard.userId,
                userName: listCard.username,
                profPicUrl: listCard.profilePic,
                dateCreated: listCard.dateCreated),
            GestureDetector(
              onTap: () => launchRankListViewScreen(
                  context: context,
                  listCard: listCard,
                  shouldPushInfo: shouldPushInfo),
              child: Text(listCard.title,
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center),
            ),
            const SizedBox(height: 10),
            listCard.picture.isNotEmpty
                ? GestureDetector(
                    onTap: () => launchRankListViewScreen(
                        context: context,
                        listCard: listCard,
                        shouldPushInfo: shouldPushInfo),
                    child: RankItemImage(imageUrl: listCard.picture))
                : SizedBox(),
            GestureDetector(
                onTap: () => launchRankListViewScreen(
                    context: context,
                    listCard: listCard,
                    shouldPushInfo: shouldPushInfo),
                child: RankPreviewItems(previewItems: listCard.rankItems)),
            hasThree
                ? GestureDetector(
                    onTap: () => launchRankListViewScreen(
                        context: context,
                        listCard: listCard,
                        shouldPushInfo: shouldPushInfo),
                    child: Text(remainingLabel,
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold)),
                  )
                : SizedBox(),
            CardFooter(
                numLikes: listCard.numLikes,
                isLiked: isLiked,
                id: listCard.listId,
                isList: true),
            listCard.commentPreview != null
                ? CommentPreviewCard(
                    listId: listCard.listId,
                    commentPreview: listCard.commentPreview,
                    numComments: listCard.numComments)
                : SizedBox()
          ],
        ),
      ),
    );
  }
}

class CardHeader extends StatelessWidget {
  final int dateCreated, userId;
  final String userName;
  final String profPicUrl;
  final bool shouldPushInfo;

  CardHeader(
      {@required this.dateCreated,
      @required this.userName,
      @required this.profPicUrl,
      @required this.userId,
      this.shouldPushInfo = true});

  @override
  Widget build(BuildContext context) {
    var isDark = Provider.of<DarkThemeProvider>(context).isDark;
    var userProvider = Provider.of<MainUserProvider>(context, listen: false);
    var textTheme = Theme.of(context)
        .textTheme
        .headline6
        .copyWith(color: isDark ? white : secondText);
    return GestureDetector(
      onTap: () {
        if (userId == userProvider.mainUser.userId) {
          Scaffold.of(context).showSnackBar(Utils.getSB("That's you!"));
          return;
        }

        if (shouldPushInfo) {
          Navigator.pushNamed(context, '/user_info_screen',
              arguments: UserInfoScreenArgs(name: userName, userId: userId));
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 14, left: 14, right: 20, bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(children: [
              CircleImage(profPicUrl: profPicUrl, userName: userName),
              const SizedBox(width: 8),
              Text(userName, style: textTheme)
            ]),
            Text(Utils.getTimeDiff(dateCreated), style: textTheme)
          ],
        ),
      ),
    );
  }
}

class CircleImage extends StatelessWidget {
  final String profPicUrl;
  final String userName;
  final double size, textSize;

  CircleImage(
      {@required this.profPicUrl,
      @required this.userName,
      this.size = 60.0,
      this.textSize = 26});

  @override
  Widget build(BuildContext context) {
    var profPic = profPicUrl.isEmpty
        ? Container(
            width: size,
            height: size,
            child: Center(
              child: Text(userName[0],
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: Colors.black, fontSize: textSize)),
            ),
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: Utils.getRandomColor(),
            ))
        : Container(
            width: size,
            height: size,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.fill, image: new NetworkImage(profPicUrl))));

    return profPic;
  }
}

class RankPreviewItem extends StatelessWidget {
  final int rank;
  final String rankItemTitle;

  RankPreviewItem({Key key, @required this.rank, @required this.rankItemTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDark = Provider.of<DarkThemeProvider>(context, listen: false).isDark;
    return Row(
      children: [
        RankCircle(rank: rank),
        const SizedBox(width: 10),
        Expanded(
            child: Text(rankItemTitle,
                style: Theme.of(context).textTheme.headline5.copyWith(
                    fontSize: 26, color: isDark ? white : Colors.black)))
      ],
    );
  }
}

class CardFooter extends StatefulWidget {
  final int numLikes;
  final bool isLiked, isList;
  final int id;

  CardFooter({
    @required this.numLikes,
    @required this.id,
    @required this.isLiked,
    this.isList = true,
  });

  @override
  _CardFooterState createState() => _CardFooterState();
}

class _CardFooterState extends State<CardFooter> {
  int _numLikes;
  bool _isLiked;
  bool _error;
  Future<LikeResponse> likeFuture;

  @override
  void initState() {
    super.initState();
    _numLikes = widget.numLikes;
    _isLiked = widget.isLiked;
    _error = false;
    likeFuture =
        Future.delayed(Duration(milliseconds: 5), () => LikeResponse.init);
  }

  @override
  Widget build(BuildContext context) {
    var loading = Padding(
        padding: const EdgeInsets.all(15),
        child: const SpinKitFoldingCube(size: 30, color: hanPurple));
    var userProvider = Provider.of<MainUserProvider>(context, listen: false);

    return FutureBuilder<LikeResponse>(
        future: likeFuture,
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
              _error = true;
              liked = _isLiked;
            } else {
              return loading;
            }

            _isLiked = liked;

            if (_numLikes < 0) {
              _numLikes = 0;
            }

            return Padding(
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
                        icon: Icon(
                            liked ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red),
                        iconSize: 55,
                        onPressed: () {
                          setState(() {
                            _error = false;
                            likeFuture = widget.isList
                                ? userProvider.likeList(widget.id)
                                : userProvider.likeComment(widget.id);
                          });
                        },
                      ),
                      Column(children: [
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () => showLikedUsers(
                              context: context, listId: widget.id),
                          child: Text(
                            _error ? "Try Again" : "$_numLikes likes",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        )
                      ])
                    ],
                  ),
                ],
              ),
            );
          }

          return loading;
        });
  }
}

class RankPreviewItems extends StatelessWidget {
  final List<RankItemPreview> previewItems;

  RankPreviewItems({@required this.previewItems});

  @override
  Widget build(BuildContext context) {
    var colChildren = List<Widget>();
    previewItems.forEach((item) {
      colChildren.add(RankPreviewItem(
          rank: item.ranking,
          rankItemTitle: item.itemName,
          key: ObjectKey(item)));
    });

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(children: colChildren));
  }
}

class CommentPreviewCard extends StatelessWidget {
  final CommentPreview commentPreview;
  final int numComments, listId;

  CommentPreviewCard(
      {@required this.commentPreview,
      @required this.numComments,
      @required this.listId});

  @override
  Widget build(BuildContext context) {
    final isDark =
        Provider.of<DarkThemeProvider>(context, listen: false).isDark;

    return Card(
        color: isDark ? hanPurple : palePurple,
        elevation: 0,
        margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CardHeader(
                  userId: commentPreview.userId,
                  dateCreated: commentPreview.dateCreated,
                  userName: commentPreview.username,
                  profPicUrl: commentPreview.profilePic),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Text(
                  commentPreview.comment,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              const SizedBox(height: 10),
              numComments > 1
                  ? GestureDetector(
                      onTap: () =>
                          showListComments(context: context, listId: listId),
                      child: Text("View all $numComments comments",
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold)),
                    )
                  : SizedBox(),
              numComments > 1 ? SizedBox(height: 10) : SizedBox()
            ],
          ),
        ));
  }
}
