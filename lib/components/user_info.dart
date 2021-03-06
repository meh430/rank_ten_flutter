import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/components/choose_pic.dart';
import 'package:rank_ten/events/user_events.dart';
import 'package:rank_ten/misc/app_theme.dart';
import 'package:rank_ten/models/user.dart';
import 'package:rank_ten/providers/dark_theme_provider.dart';
import 'package:rank_ten/providers/main_user_provider.dart';
import 'package:rank_ten/repos/ranked_list_preview_repository.dart';
import 'package:rank_ten/repos/user_preview_repository.dart';
import 'package:rank_ten/repos/user_repository.dart';
import 'package:rank_ten/routes/list_screen.dart';
import 'package:rank_ten/routes/user_preview_screen.dart';

import '../misc/utils.dart';
import 'login.dart';

class UserInfo extends StatelessWidget {
  final User user;
  final bool isMain;

  UserInfo({@required this.user, this.isMain = false});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<MainUserProvider>(context);
    Widget profilePic =
        RoundedImage(imageUrl: user.profilePic, uInitial: user.username[0]);
    profilePic = isMain
        ? GestureDetector(
            child: profilePic,
            onTap: () => showProfilePicker(
                context: context,
                url: user.profilePic,
                setImage: (String imageUrl) {
                  userProvider.addUserEvent(UpdateProfilePicEvent(
                      profilePic: imageUrl, token: userProvider.jwtToken));
                }))
        : profilePic;

    Widget cardChild;

    if (isMain) {
      cardChild = Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //RoundedImage(imageUrl: user.profPic, uInitial: user.userName[0]),
          profilePic,
          Expanded(
            child: UserStatRow(
              user: user,
              isMain: isMain,
            ),
          ),
          SizedBox(
            width: 12,
          )
        ],
      );
    } else {
      cardChild = Column(children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //RoundedImage(imageUrl: user.profPic, uInitial: user.userName[0]),
            profilePic,
            Expanded(
              child: UserStatRow(
                user: user,
                isMain: isMain,
              ),
            ),
            SizedBox()
          ],
        ),
        FollowButton(
            isFollowing: userProvider.mainUser.following.contains(user.userId),
            username: user.username,
            userId: user.userId)
      ]);
    }

    return Card(
        margin: const EdgeInsets.all(10.0),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: cardChild);
  }
}

class FollowButton extends StatefulWidget {
  final bool isFollowing;
  final String username;
  final int userId;

  FollowButton(
      {Key key,
      @required this.isFollowing,
      @required this.username,
      @required this.userId})
      : super(key: key);

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool _isFollowing;
  Future<FollowResponse> followFuture;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.isFollowing;
    followFuture =
        Future.delayed(Duration(milliseconds: 5), () => FollowResponse.init);
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<MainUserProvider>(context);
    var loading = Padding(
      padding: const EdgeInsets.all(10),
      child: const SpinKitDoubleBounce(size: 50, color: hanPurple),
    );

    return FutureBuilder<FollowResponse>(
      future: followFuture,
      key: UniqueKey(),
      builder: (BuildContext context, AsyncSnapshot<FollowResponse> snapshot) {
        var buttonText = "";

        if (snapshot.hasData) {
          if (snapshot.data == FollowResponse.init) {
            buttonText = _isFollowing ? "Following" : "Follow";
          } else if (snapshot.data == FollowResponse.followed) {
            buttonText = "Following";
            _isFollowing = true;
          } else if (snapshot.data == FollowResponse.unfollowed) {
            buttonText = "Follow";
            _isFollowing = false;
          } else if (snapshot.data == FollowResponse.error) {
            buttonText = "Try Again";
          } else {
            return loading;
          }

          return Padding(
            padding: const EdgeInsets.all(10),
            child: RaisedButton(
                color: hanPurple,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                  child: Text(buttonText,
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(color: white)),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                onPressed: () {
                  setState(() {
                    followFuture =
                        userProvider.followUser(userId: widget.userId);
                  });
                }),
          );
        }

        return loading;
      },
    );
    /*return Padding(
      padding: const EdgeInsets.all(10),
      child: RaisedButton(
          color: hanPurple,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
            child: Text(_isFollowing ? "Followed" : "Follow",
                style: Theme
                    .of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: white)),
          ),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          onPressed: () async {
            if (!_runningFollow) {
              _runningFollow = true;
              var status = "";
              try {
                status = await userProvider.followUser(
                    name: widget.name, userId: widget.id);
              } catch (e) {
                print("error $e");
                if (!(status is String)) {
                  return;
                }
              }
              print(status);
              setState(() {
                _isFollowing = status == "FOLLOW";
              });
              Future.delayed(
                  Duration(milliseconds: 2500), () => _runningFollow = false);
            } else {
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(Utils.getSB('Please wait'));
            }
          }),
    );*/
  }
}

class RoundedImage extends StatelessWidget {
  final String imageUrl;
  final String uInitial;

  RoundedImage({@required this.imageUrl, @required this.uInitial});

  @override
  Widget build(BuildContext context) {
    var image = imageUrl != ""
        ? ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
            child: FadeInImage.assetNetwork(
              placeholder: "assets/loading.gif",
              image: imageUrl,
              height: 130,
              width: 130,
              fit: BoxFit.cover,
            ))
        : getProfilePic(uInitial, context);

    return Padding(
      child: image,
      padding: const EdgeInsets.all(12.0),
    );
  }
}

class UserStat extends StatelessWidget {
  final int statCount;
  final String statLabel;
  final bool isMain;

  UserStat(
      {@required this.statLabel,
      @required this.statCount,
      this.isMain = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          Text(
            statCount.toString(),
            style: Theme.of(context)
                .primaryTextTheme
                .headline6
                .copyWith(fontSize: isMain ? 14 : 18),
          ),
          Text(statLabel,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontSize: isMain ? 14 : 18))
        ],
      ),
    );
  }
}

class UserStatRow extends StatelessWidget {
  final User user;
  final bool isMain;

  UserStatRow({@required this.user, this.isMain = false});

  @override
  Widget build(BuildContext context) {
    final token =
        Provider.of<MainUserProvider>(context, listen: false).jwtToken;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Column(
            children: [
              UserStat(
                statLabel: "Rank Points",
                statCount: user.rankPoints,
                isMain: isMain,
              ),
              GestureDetector(
                onTap: () {
                  if (isMain) {
                    //private
                    Navigator.pushNamed(context, '/lists',
                        arguments: ListScreenArgs(
                            listType: USER_LISTS_ALL,
                            token: token,
                            userId: user.userId,
                            username: user.username));
                  } else {
                    //public
                    Navigator.pushNamed(context, '/lists',
                        arguments: ListScreenArgs(
                            listType: USER_LISTS,
                            username: user.username,
                            userId: user.userId));
                  }
                },
                child: UserStat(
                  statLabel: "Rank Lists",
                  statCount: user.numLists,
                  isMain: isMain,
                ),
              )
            ],
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/user_preview_list',
                    arguments: UserPreviewScreenArgs(
                        listType: FOLLOWING_USERS,
                        username: user.username,
                        id: user.userId)),
                child: UserStat(
                  statLabel: "Following",
                  statCount: user.numFollowing,
                  isMain: isMain,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/user_preview_list',
                    arguments: UserPreviewScreenArgs(
                        listType: FOLLOWERS_USERS,
                        username: user.username,
                        id: user.userId)),
                child: UserStat(
                  statLabel: "Followers",
                  statCount: user.numFollowers,
                  isMain: isMain,
                ),
              ),
            ],
          ),
          isMain
              ? Column(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, '/user_comments_screen'),
                      child: UserStat(
                        statLabel: "Comments",
                        statCount: user.numComments,
                        isMain: isMain,
                      ),
                    ),
                    GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/lists',
                            arguments: ListScreenArgs(
                                listType: LIKED_LISTS,
                                username: user.username,
                                userId: user.userId,
                                token: token)),
                        child: UserStat(
                          statLabel: "Liked Lists",
                          statCount: user.likedLists.length,
                          isMain: isMain,
                        ))
                  ],
                )
              : SizedBox()
        ],
      ),
    );
  }
}

class UserBio extends StatelessWidget {
  final User user;
  final bool isMain;

  UserBio({@required this.user, this.isMain = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: MediaQuery.of(context).size.width),
            isMain ? BioEditWidget(bio: user.bio) : BioWidget(bio: user.bio),
            const SizedBox(height: 10),
            Text("Date Created",
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: getTitleColor(context))),
            Text(Utils.getDate(user.dateCreated),
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(fontSize: 18))
          ],
        ),
      ),
    );
  }
}

class BioWidget extends StatelessWidget {
  final String bio;

  BioWidget({@required this.bio});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Bio",
          textAlign: TextAlign.start,
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(color: getTitleColor(context)),
        ),
        Text(bio.isNotEmpty ? bio : "This person does not have a bio...",
            style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 18))
      ],
    );
  }
}

class BioEditWidget extends StatefulWidget {
  final String bio;

  BioEditWidget({@required this.bio});

  @override
  _BioEditWidgetState createState() => _BioEditWidgetState();
}

class _BioEditWidgetState extends State<BioEditWidget> {
  String _currBio;
  bool _editing = false;
  TextEditingController _bController;

  @override
  void initState() {
    super.initState();
    setState(() => _currBio = widget.bio);
    _bController = TextEditingController(text: widget.bio);
  }

  Widget getBioEditField() {
    final userProvider = Provider.of<MainUserProvider>(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return TextField(
      onSubmitted: (String value) {
        if (value.isEmpty) {
          Scaffold.of(context).showSnackBar(Utils.getSB('Bio cannot be empty'));
        } else {
          _editing = false;
          userProvider.addUserEvent(
              UpdateBioEvent(bio: value, token: userProvider.jwtToken));
        }
      },
      textInputAction: TextInputAction.done,
      controller: _bController,
      maxLines: null,
      style: TextStyle(color: themeChange.isDark ? white : Colors.black),
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20.0),
          border: getInputStyle(themeChange.isDark),
          enabledBorder: getInputStyle(themeChange.isDark),
          focusedBorder: getInputStyle(themeChange.isDark)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Bio",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(color: getTitleColor(context)),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => setState(() => _editing = !_editing),
            )
          ],
        ),
        _editing
            ? getBioEditField()
            : Text(_currBio,
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(fontSize: 18))
      ],
    );
  }
}

Widget getProfilePic(String uInitial, BuildContext context) {
  return Container(
    width: 130.0,
    height: 130.0,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: Utils.getRandomColor()),
    child: Center(
        child: Text((uInitial ?? "I").toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .headline2
                .copyWith(color: Colors.black))),
  );
}

Color getTitleColor(BuildContext context) {
  return Provider.of<DarkThemeProvider>(context).isDark ? lavender : hanPurple;
}
