import 'package:flutter/material.dart';
import 'package:rank_ten/misc/app_theme.dart';

const bRadius = const Radius.circular(15.0);
const rankScale = 0.62;
const tenScale = 0.38;

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final totalWidth = 304.8;
    final height = totalWidth / 2.7;
    return Container(
      width: totalWidth,
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 5.0,
            child: Container(
              decoration: const BoxDecoration(
                  color: palePurple,
                  borderRadius: const BorderRadius.only(
                      topRight: bRadius, bottomRight: bRadius)),
              width: totalWidth * tenScale,
              height: height,
              child: Center(
                child: Text("10",
                    style: Theme.of(context)
                        .primaryTextTheme
                        .headline3
                        .copyWith(color: darkSienna)),
              ),
            ),
          ),
          Positioned(
            left: 5.0,
            child: Container(
              decoration: const BoxDecoration(
                  color: hanPurple, borderRadius: BorderRadius.all(bRadius)),
              width: totalWidth * rankScale,
              height: height,
              child: Center(
                  child: Text("Rank",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .headline2
                          .copyWith(color: white))),
            ),
          ),
        ],
      ),
    );
  }
}
