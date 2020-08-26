import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/api/preferences_store.dart';
import 'package:rank_ten/api/response.dart';
import 'package:rank_ten/blocs/preview_lists_bloc.dart';
import 'package:rank_ten/components/user_info.dart';
import 'package:rank_ten/components/user_top_lists.dart';
import 'package:rank_ten/events/ranked_list_preview_events.dart';
import 'package:rank_ten/events/user_events.dart';
import 'package:rank_ten/misc/app_theme.dart';
import 'package:rank_ten/models/ranked_list_card.dart';
import 'package:rank_ten/models/user.dart';
import 'package:rank_ten/providers/main_user_provider.dart';
import 'package:rank_ten/repos/ranked_list_preview_repository.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainUserInfoBuilder();
  }
}

class MainUserInfoBuilder extends StatefulWidget {
  @override
  _MainUserInfoBuilderState createState() => _MainUserInfoBuilderState();
}

class _MainUserInfoBuilderState extends State<MainUserInfoBuilder> {
  MainUserProvider _userProvider;
  PreviewListsBloc _listsBloc;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<MainUserProvider>(context, listen: false);
    _listsBloc = PreviewListsBloc(endpointBase: USER_TOP_LISTS);

    _listsBloc.listEventSink
        .add(RankedListPreviewEvent(name: _userProvider.mainUser.userName));
  }

  @override
  void dispose() {
    super.dispose();
    _listsBloc.dispose();
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
      color: hanPurple,
      size: 50,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () =>
          Future.delayed(Duration(milliseconds: 0), () {
            _userProvider.addUserEvent(
                GetUserEvent(_userProvider.mainUser.userName,
                    token: _userProvider.jwtToken));
            _listsBloc.listEventSink.add(RankedListPreviewEvent(
                name: _userProvider.mainUser.userName, refresh: true));
          }),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: const AlwaysScrollableScrollPhysics()),
        child: Column(children: [
          StreamBuilder<Response<User>>(
              stream: _userProvider.mainUserBloc.userStateStream,
              initialData: Response.completed(_userProvider.mainUser),
              builder: builderFunction),
          StreamBuilder<List<RankedListCard>>(
            stream: _listsBloc.listStateStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return UserTopLists(
                    name: _userProvider.mainUser.userName,
                    topLists: snapshot.data);
              } else if (snapshot.hasError) {
                return Text("Error getting top lists",
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline5);
              }

              return SpinKitRipple(size: 50, color: hanPurple);
            },
          )
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
