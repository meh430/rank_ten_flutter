import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/api/preferences_store.dart';
import 'package:rank_ten/api/response.dart';
import 'package:rank_ten/blocs/user_bloc.dart';
import 'package:rank_ten/components/user_info.dart';
import 'package:rank_ten/components/user_top_lists.dart';
import 'package:rank_ten/events/user_events.dart';
import 'package:rank_ten/misc/app_theme.dart';
import 'package:rank_ten/models/user.dart';
import 'package:rank_ten/providers/main_user_provider.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UserInfoBuilder();
  }
}

class UserInfoBuilder extends StatefulWidget {
  @override
  _UserInfoBuilderState createState() => _UserInfoBuilderState();
}

class _UserInfoBuilderState extends State<UserInfoBuilder> {
  MainUserProvider _userProvider;
  UserBloc _mainUserBloc;
  bool refresh = false;

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
          return SpinKitWave(
            size: 50,
            color: hanPurple,
          );
          break;
        case Status.ERROR:
          return Text('Error getting user data',
              style: Theme.of(context).primaryTextTheme.headline3);
          //Scaffold.of(context)
          //    .showSnackBar(Utils.getSB('Error getting user data'));
          break;
        case Status.COMPLETED:
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              UserInfo(user: snapshot.data.value, isMain: true),
              UserBio(user: snapshot.data.value, isMain: true),
            ],
          );
      }
    }
    return SpinKitWave(
      size: 50,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () =>
          Future.delayed(Duration(milliseconds: 0), () {
            _mainUserBloc.userEventSink
                .add(GetUserEvent(_userProvider.mainUser.userName,
                token: _userProvider.jwtToken));
            setState(() {
              print("Refresh $refresh");
              refresh = !refresh;
            });
          }),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: const AlwaysScrollableScrollPhysics()),
        child: Column(children: [
          StreamBuilder<Response<User>>(
              key: UniqueKey(),
              stream: _mainUserBloc.userStateStream,
              initialData: Response.completed(_userProvider.mainUser),
              builder: builderFunction),
          UserTopLists(
              name: _userProvider.mainUser.userName,
              refresh: refresh,
              key: UniqueKey())
        ]),
      ),
    );
  }
}

class LogOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding:
          const EdgeInsets.only(left: 40.0, right: 40.0, top: 8.0, bottom: 8.0),
      color: paraPink,
      onPressed: () {
        PreferencesStore().clearAll();
        Provider.of<MainUserProvider>(context, listen: false).logOut();
        Navigator.pop(context);
        Navigator.pushNamed(context, '/login_signup');
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: Text("Log Out",
          style: Theme.of(context)
              .primaryTextTheme
              .headline3
              .copyWith(color: palePurple)),
    );
  }
}
