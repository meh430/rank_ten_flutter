import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/blocs/ranked_list_bloc.dart';
import 'package:rank_ten/events/ranked_list_events.dart';
import 'package:rank_ten/misc/app_theme.dart';
import 'package:rank_ten/models/ranked_list.dart';
import 'package:rank_ten/providers/dark_theme_provider.dart';

class RankedListViewScreen extends StatefulWidget {
  final String listId, listTitle;
  final bool isMain;

  RankedListViewScreen({Key key, this.listId, this.listTitle, this.isMain})
      : super(key: key);

  @override
  _RankedListViewScreenState createState() => _RankedListViewScreenState();
}

class _RankedListViewScreenState extends State<RankedListViewScreen> {
  RankedListBloc _rankedListBloc;

  @override
  void initState() {
    super.initState();
    _rankedListBloc = RankedListBloc();
    _rankedListBloc.rankedListEventSink.add(GetRankedListEvent(widget.listId));
  }

  @override
  Widget build(BuildContext context) {
    var isDark = Provider.of<DarkThemeProvider>(context).isDark;
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          brightness: isDark ? Brightness.dark : Brightness.light,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(widget.listTitle,
              style: Theme.of(context).primaryTextTheme.headline5),
        ),
        body: StreamBuilder<RankedList>(
            stream: _rankedListBloc.rankedListStateStream,
            builder:
                (BuildContext context, AsyncSnapshot<RankedList> snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.userName);
              }

              return SpinKitRipple(size: 50, color: hanPurple);
            }));
  }
}

class RankedListViewScreenArgs {
  final String listId, listTitle;
  final bool isMain;

  RankedListViewScreenArgs(
      {@required this.listId, @required this.listTitle, this.isMain = false});
}
