import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(),
    );
  }
}

Widget getRoundedImage(String url) {
  return Container(
      width: 190.0,
      height: 190.0,
      decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
              fit: BoxFit.fill, image: new NetworkImage(url))));
}

Widget getUserStats(
    {int rankPoints, int numFollowers, int numFollowing, int numLists}) {
  return Row(
    children: [],
  );
}
