import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rank_ten/logo.dart';

import 'app_theme.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 2000),
        () => Navigator.pushNamed(context, '/login_signin'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
          Logo(),
          SizedBox(height: 200, width: 50),
          SpinKitCubeGrid(
            color: hanPurple,
            size: 70.0,
          )
        ])));
  }
}
