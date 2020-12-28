import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/api/preferences_store.dart';
import 'package:rank_ten/components/generic_list_preview_widget.dart';
import 'package:rank_ten/providers/dark_theme_provider.dart';
import 'package:rank_ten/repos/ranked_list_preview_repository.dart';
import 'package:rank_ten/routes/main_screen.dart';

class ListScreen extends StatefulWidget {
  final String listType, username, token;
  final int userId;

  ListScreen(
      {Key key,
      @required this.listType,
      this.username,
      this.userId,
      this.token})
      : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  int _sortOption = PreferencesStore.currentSort;
  String appBarTitle = "Lists";

  @override
  void initState() {
    super.initState();
    appBarTitle = widget.listType == LIKED_LISTS
        ? 'Liked Lists'
        : "${widget.username}'s lists";
  }

  void _sortCallback(int option) {
    setState(() {
      _sortOption = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    var isDark = Provider.of<DarkThemeProvider>(context, listen: false).isDark;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        brightness: isDark ? Brightness.dark : Brightness.light,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          getSortAction(
              context: context, sortCallback: _sortCallback, isDark: isDark)
        ],
        title: Text(appBarTitle,
            style: Theme.of(context).primaryTextTheme.headline5),
      ),
      body: GenericListPreviewWidget(
          key: UniqueKey(),
          listType: widget.listType,
          userId: widget.userId,
          token: widget.token,
          sort: _sortOption),
    );
  }
}

class ListScreenArgs {
  final String listType, username, token;
  final int userId;

  ListScreenArgs(
      {@required this.listType,
      this.userId = 0,
      this.username = "",
      this.token = ""});
}
