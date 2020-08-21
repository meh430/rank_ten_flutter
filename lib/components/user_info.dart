import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rank_ten/app_theme.dart';
import 'package:rank_ten/models/user.dart';

class UserInfo extends StatelessWidget {
  final User user;

  UserInfo({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          RoundedImage(imageUrl: user.profPic, uInitial: user.userName[0]),
          const SizedBox(width: 20),
          UserStatRow(user: user)
        ],
      ),
    );
  }
}

class RoundedImage extends StatelessWidget {
  final String imageUrl;
  final String uInitial;

  RoundedImage({this.imageUrl, this.uInitial});

  @override
  Widget build(BuildContext context) {
    var image = imageUrl != ""
        ? Container(
            width: 120.0,
            height: 120.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                image: DecorationImage(
                    fit: BoxFit.fill, image: NetworkImage(imageUrl))))
        : getProfilePic(uInitial, context);

    return Padding(
      child: image,
      padding: EdgeInsets.all(12.0),
    );
  }
}

class UserStat extends StatelessWidget {
  final int statCount;
  final String statLabel;

  UserStat({@required this.statLabel, @required this.statCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          Text(
            statCount.toString(),
            style: Theme
                .of(context)
                .primaryTextTheme
                .headline6,
          ),
          Text(statLabel, style: Theme
              .of(context)
              .primaryTextTheme
              .headline6)
        ],
      ),
    );
  }
}

class UserStatRow extends StatelessWidget {
  final User user;

  UserStatRow({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Column(
          children: [
            UserStat(statLabel: "Rank Points", statCount: user.rankPoints),
            UserStat(statLabel: "Rank Lists", statCount: user.listNum),
          ],
        ),
        Column(
          children: [
            UserStat(statLabel: "Following", statCount: user.numFollowing),
            UserStat(statLabel: "Followers", statCount: user.numFollowers)
          ],
        )
      ],
    );
  }
}

//TODO: make editable?
class UserBio extends StatelessWidget {
  final User user;

  UserBio({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bio",
              style: Theme
                  .of(context)
                  .primaryTextTheme
                  .headline5,
            ),
            Text(user.bio,
                style: Theme
                    .of(context)
                    .primaryTextTheme
                    .headline4
                    .copyWith(fontSize: 16)),
            const SizedBox(height: 10),
            Text("Date Created",
                style: Theme
                    .of(context)
                    .primaryTextTheme
                    .headline5),
            Text(user.dateCreated.toString(),
                style: Theme
                    .of(context)
                    .primaryTextTheme
                    .headline4
                    .copyWith(fontSize: 16))
          ],
        ),
      ),
    );
  }
}

Widget getProfilePic(String uInitial, BuildContext context) {
  var colors = [
    Colors.red,
    Colors.green,
    Colors.amber,
    Colors.amberAccent,
    Colors.purple,
    hanPurple,
    paraPink
  ];
  return Container(
    width: 130.0,
    height: 130.0,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: colors[Random().nextInt(colors.length)]),
    child: Center(
        child: Text(uInitial.toUpperCase(),
            style: Theme
                .of(context)
                .primaryTextTheme
                .headline2
                .copyWith(color: Colors.black))),
  );
}
