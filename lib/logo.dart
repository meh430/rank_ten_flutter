import 'package:flutter/material.dart';
import 'package:rank_ten/app_theme.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return Row(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(color: hanPurple),
          width: 100,
          height: 60,
          child: Text("Rank"),
        ),
      ],
    );
  }
}
