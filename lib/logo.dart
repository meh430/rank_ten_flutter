import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rank_ten/app_theme.dart';

const bRadius = Radius.circular(15.0);
const rankScale = 0.62;
const tenScale = 0.38;

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final totalWidth = MediaQuery.of(context).size.width / 1.5;
    final height = totalWidth / 2.7;

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        width: totalWidth,
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              right: 5.0,
              child: Container(
                decoration: BoxDecoration(
                    color: palePurple,
                    borderRadius: BorderRadius.only(
                        topRight: bRadius, bottomRight: bRadius)),
                width: totalWidth * tenScale,
                height: height,
                child: Center(
                  child: Text("10",
                      style: Theme.of(context).primaryTextTheme.headline3),
                ),
              ),
            ),
            Positioned(
              left: 5.0,
              child: Container(
                decoration: BoxDecoration(
                    color: hanPurple, borderRadius: BorderRadius.all(bRadius)),
                width: totalWidth * rankScale,
                height: height,
                child: Center(
                    child: Text("Rank",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline3
                            .copyWith(color: white))),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 200, width: 50),
      SpinKitCubeGrid(
        color: hanPurple,
        size: 70.0,
      )
    ]);
  }
}
