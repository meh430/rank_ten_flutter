import 'package:flutter/material.dart';
import 'package:rank_ten/app_theme.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          ColoredBox(
            color: hanPurple,
          ),
          ColoredBox(color: palePurple)
        ],
      ),
    );
  }
}
