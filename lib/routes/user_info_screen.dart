import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/api/preferences_store.dart';
import 'package:rank_ten/api/response.dart';
import 'package:rank_ten/blocs/preview_lists_bloc.dart';
import 'package:rank_ten/blocs/user_bloc.dart';
import 'package:rank_ten/components/user_info.dart';
import 'package:rank_ten/components/user_top_lists.dart';
import 'package:rank_ten/events/ranked_list_preview_events.dart';
import 'package:rank_ten/events/user_events.dart';
import 'package:rank_ten/misc/app_theme.dart';
import 'package:rank_ten/misc/utils.dart';
import 'package:rank_ten/models/ranked_list_card.dart';
import 'package:rank_ten/models/user.dart';
import 'package:rank_ten/providers/dark_theme_provider.dart';
import 'package:rank_ten/repos/ranked_list_preview_repository.dart';
import 'package:rank_ten/routes/main_screen.dart';

class UserInfoScreen extends StatefulWidget {
  final String username;
  final int userId;

  UserInfoScreen({@required this.username, @required this.userId});

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  @override
  Widget build(BuildContext context) {
    var isDark = Provider.of<DarkThemeProvider>(context, listen: false).isDark;
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          brightness: isDark ? Brightness.dark : Brightness.light,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(widget.username,
              style: Theme.of(context).primaryTextTheme.headline5),
        ),
        body:
            UserInfoBuilder(username: widget.username, userId: widget.userId));
  }
}

class UserInfoBuilder extends StatefulWidget {
  final String username;
  final int userId;

  UserInfoBuilder({@required this.username, @required this.userId});

  @override
  _UserInfoBuilderState createState() => _UserInfoBuilderState();
}

class _UserInfoBuilderState extends State<UserInfoBuilder> {
  UserBloc _userBloc;
  PreviewListsBloc _listsBloc;
  var _sortOption = PreferencesStore.currentSort;

  void _sortCallback(int option) {
    _sortOption = option;
    PreferencesStore.saveSort(option);
    _listsBloc.resetPage();
    _listsBloc.addEvent(
        RankedListPreviewEvent(userId: widget.userId, sort: _sortOption));
  }

  @override
  void initState() {
    super.initState();
    _userBloc = UserBloc(userId: widget.userId);
    _listsBloc = PreviewListsBloc(endpointBase: USER_TOP_LISTS);
    _listsBloc.addEvent(
        RankedListPreviewEvent(userId: widget.userId, sort: _sortOption));
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
              (_) => Utils.showSB("Error getting user info", context));
          return Utils.getErrorImage();
        case Status.COMPLETED:
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              UserInfo(user: snapshot.data.value, isMain: false),
              UserBio(user: snapshot.data.value, isMain: false),
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
        _userBloc.userEventSink.add(GetUserEvent(widget.userId));
        _listsBloc.addEvent(RankedListPreviewEvent(
            userId: widget.userId, sort: _sortOption, refresh: true));
      }),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: const AlwaysScrollableScrollPhysics()),
        child: Column(children: [
          StreamBuilder<Response<User>>(
              stream: _userBloc.userStateStream, builder: builderFunction),
          StreamBuilder<List<RankedListCard>>(
            stream: _listsBloc.modelStateStream,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Row(
                          children: [
                            Text("${widget.username}'s Lists",
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
                        key: UniqueKey(),
                        name: widget.username,
                        topLists: snapshot.data),
                  ],
                );
              } else if (snapshot.hasError || snapshot.data == null) {
                WidgetsBinding.instance.addPostFrameCallback(
                    (_) => Utils.showSB("Error getting top lists", context));
                return Utils.getErrorImage();
              }

              return Padding(
                padding: const EdgeInsets.all(10),
                child: SpinKitThreeBounce(size: 30, color: hanPurple),
              );
            },
          )
        ]),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _userBloc.dispose();
    _listsBloc.dispose();
  }
}

class UserInfoScreenArgs {
  final String username;
  final int userId;

  UserInfoScreenArgs({@required this.username, @required this.userId});
}
