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
import 'package:rank_ten/misc/utils.dart';
import 'package:rank_ten/models/ranked_list_card.dart';
import 'package:rank_ten/models/user.dart';
import 'package:rank_ten/providers/dark_theme_provider.dart';
import 'package:rank_ten/providers/main_user_provider.dart';
import 'package:rank_ten/repos/ranked_list_preview_repository.dart';
import 'package:rank_ten/routes/main_screen.dart';

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
  var _sortOption = PreferencesStore.currentSort;

  void _sortCallback(int option) {
    _sortOption = option;
    PreferencesStore.saveSort(_sortOption);
    _listsBloc.resetPage();
    _listsBloc.addEvent(RankedListPreviewEvent(
        userId: _userProvider.mainUser.userId,
        token: _userProvider.jwtToken,
        sort: _sortOption));
  }

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<MainUserProvider>(context, listen: false);
    _listsBloc = PreviewListsBloc(endpointBase: USER_TOP_LISTS);
    _listsBloc.addEvent(RankedListPreviewEvent(
        userId: _userProvider.mainUser.userId,
        token: _userProvider.jwtToken,
        sort: _sortOption));
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
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => Utils.showSB("Error getting user data", context));
          return Utils.getErrorImage();
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
      onRefresh: () => Future.delayed(Duration(milliseconds: 0), () {
        _userProvider.addUserEvent(GetUserEvent(_userProvider.mainUser.userId,
            token: _userProvider.jwtToken));
        _listsBloc.addEvent(RankedListPreviewEvent(
            token: _userProvider.jwtToken,
            sort: _sortOption,
            userId: _userProvider.mainUser.userId,
            refresh: true));
      }),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: const AlwaysScrollableScrollPhysics()),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          StreamBuilder<Response<User>>(
              stream: _userProvider.mainUserBloc.userStateStream,
              initialData: Response.completed(_userProvider.mainUser),
              builder: builderFunction),
          StreamBuilder<List<RankedListCard>>(
            stream: _listsBloc.modelStateStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Row(
                          children: [
                            Text("${_userProvider.mainUser.username}'s Lists",
                                style: Theme.of(context).textTheme.headline5),
                            getSortAction(
                                context: context,
                                isDark: Provider.of<DarkThemeProvider>(context,
                                        listen: false)
                                    .isDark,
                                sortCallback: _sortCallback)
                          ],
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        )),
                    UserTopLists(
                        name: _userProvider.mainUser.username,
                        topLists: snapshot.data),
                  ],
                );
              } else if (snapshot.hasError) {
                WidgetsBinding.instance.addPostFrameCallback(
                    (_) => Utils.showSB("Error getting top lists", context));
                return Utils.getErrorImage();
              }

              return Padding(
                padding: const EdgeInsets.all(15),
                child: SpinKitThreeBounce(size: 30, color: hanPurple),
              );
            },
          ),
          SizedBox(
            height: 100,
          )
        ]),
      ),
    );
  }
}

class LogOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: RaisedButton(
          color: hanPurple,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
            child: Text("Log Out",
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: white)),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          onPressed: () {
            PreferencesStore.clearAll();
            Provider.of<MainUserProvider>(context, listen: false).logOut();
            Navigator.pop(context);
            Navigator.pushNamed(context, '/login_signup');
          }),
    );
  }
}
/*return RaisedButton(
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
* */
