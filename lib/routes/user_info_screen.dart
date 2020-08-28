import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/api/response.dart';
import 'package:rank_ten/blocs/preview_lists_bloc.dart';
import 'package:rank_ten/blocs/user_bloc.dart';
import 'package:rank_ten/components/user_info.dart';
import 'package:rank_ten/components/user_top_lists.dart';
import 'package:rank_ten/events/ranked_list_preview_events.dart';
import 'package:rank_ten/events/user_events.dart';
import 'package:rank_ten/misc/app_theme.dart';
import 'package:rank_ten/models/ranked_list_card.dart';
import 'package:rank_ten/models/user.dart';
import 'package:rank_ten/providers/dark_theme_provider.dart';
import 'package:rank_ten/repos/ranked_list_preview_repository.dart';

class UserInfoScreen extends StatefulWidget {
  final String name;

  UserInfoScreen({this.name});

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  @override
  Widget build(BuildContext context) {
    var isDark = Provider.of<DarkThemeProvider>(context).isDark;
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          brightness: isDark ? Brightness.dark : Brightness.light,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(widget.name,
              style: Theme.of(context).primaryTextTheme.headline5),
        ),
        body: UserInfoBuilder(name: widget.name));
  }
}

class UserInfoBuilder extends StatefulWidget {
  final String name;

  UserInfoBuilder({this.name});

  @override
  _UserInfoBuilderState createState() => _UserInfoBuilderState();
}

class _UserInfoBuilderState extends State<UserInfoBuilder> {
  UserBloc _userBloc;
  PreviewListsBloc _listsBloc;

  @override
  void initState() {
    super.initState();
    _userBloc = UserBloc(name: widget.name);
    _listsBloc = PreviewListsBloc(endpointBase: USER_TOP_LISTS);
    _listsBloc.modelEventSink.add(RankedListPreviewEvent(name: widget.name));
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
          break;
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
        _userBloc.userEventSink.add(GetUserEvent(widget.name));
        _listsBloc.modelEventSink
            .add(RankedListPreviewEvent(name: widget.name, refresh: true));
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
              if (snapshot.hasData) {
                return UserTopLists(name: widget.name, topLists: snapshot.data);
              } else if (snapshot.hasError) {
                return Text("Error getting top lists",
                    style: Theme.of(context).textTheme.headline5);
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
  final String name;

  UserInfoScreenArgs({@required this.name});
}
