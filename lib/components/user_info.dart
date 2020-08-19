import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(),
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

//inherited widget?
class UserStatRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
