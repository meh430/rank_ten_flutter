import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/components/user_info.dart';
import 'package:rank_ten/components/user_lists.dart';
import 'package:rank_ten/main_user_provider.dart';
import 'package:rank_ten/user_bloc.dart';

import 'api/response.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [UserInfoBuilder(), UserLists()],
    );
  }
}

class UserInfoBuilder extends StatefulWidget {
  @override
  _UserInfoBuilderState createState() => _UserInfoBuilderState();
}

class _UserInfoBuilderState extends State<UserInfoBuilder> {
  MainUserProvider _userProvider;
  UserBloc _mainUserBloc;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<MainUserProvider>(context, listen: false);
    _mainUserBloc = _userProvider.mainUserBloc;
  }

  Widget builderFunction(
      BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    if (snapshot.hasData) {
      switch (snapshot.data.status) {
        case Status.LOADING:
          return SpinKitFadingCube(size: 50);
          break;
        case Status.ERROR:
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Error loading user info"),
          ));
          break;
        case Status.COMPLETED:
          return Column(
            children: [
              UserInfo(user: snapshot.data.value),
              UserBio(user: snapshot.data.value)
            ],
          );
      }
    } else {
      return SpinKitFadingCube(
        size: 50,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _mainUserBloc.userStateStream,
        initialData: Response.completed(_userProvider.mainUser),
        builder: builderFunction);
  }
}
