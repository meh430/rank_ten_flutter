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
      child: Row(
        children: [
          RoundedImage(imageUrl: user.profPic, uInitial: user.userName[0]),
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
            width: 100.0,
            height: 100.0,
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
    return Column(
      children: <Widget>[Text(statCount.toString()), Text(statLabel)],
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
        UserStat(statLabel: "Rank Points", statCount: user.rankPoints),
        UserStat(statLabel: "Rank Lists", statCount: user.listNum),
        UserStat(statLabel: "Following", statCount: user.numFollowing),
        UserStat(statLabel: "Followers", statCount: user.numFollowers)
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
      child: Column(
        children: [
          const Text("Bio"),
          Text(user.bio),
          const Text("Date Created"),
          Text(user.dateCreated.toString())
        ],
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
    width: 100.0,
    height: 100.0,
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
