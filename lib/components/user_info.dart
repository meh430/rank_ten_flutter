import 'package:flutter/material.dart';
import 'package:rank_ten/models/user.dart';

class UserInfo extends StatelessWidget {
  final User user;

  UserInfo({this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          RoundedImage(imageUrl: user.profPic),
          UserStatRow(user: user)
        ],
      ),
    );
  }
}

class RoundedImage extends StatelessWidget {
  final String imageUrl;

  RoundedImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 190.0,
        height: 190.0,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
                fit: BoxFit.fill, image: new NetworkImage(imageUrl))));
  }
}

class UserStat extends StatelessWidget {
  final int statCount;
  final String statLabel;

  UserStat({this.statLabel, this.statCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[Text(statCount.toString()), Text(statLabel)],
    );
  }
}

class UserStatRow extends StatelessWidget {
  final User user;

  UserStatRow({this.user});

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

  UserBio({this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const Text("Bio"),
          Text(user.bio),
          Text("Date Created"),
          Text(user.dateCreated.toString())
        ],
      ),
    );
  }
}
