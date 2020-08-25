import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/components/generic_list_preview_widget.dart';
import 'package:rank_ten/misc/utils.dart';
import 'package:rank_ten/providers/dark_theme_provider.dart';
import 'package:rank_ten/repos/ranked_list_preview_repository.dart';
import 'package:rank_ten/routes/main_screen.dart';

class ListScreen extends StatefulWidget {
  final String listType, name, token;

  ListScreen({Key key, @required this.listType, this.name, this.token})
      : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  int _sortOption = LIKES_DESC;
  String appBarTitle = "Lists";

  @override
  void initState() {
    super.initState();
    appBarTitle = widget.listType == LIKED_LISTS
        ? 'Liked Lists'
        : "${widget.name}'s lists";
  }

  void _sortCallback(String option) {
    setState(() {
      if (option.contains('like')) {
        _sortOption = LIKES_DESC;
      } else if (option.contains('newest')) {
        _sortOption = DATE_DESC;
      } else if (option.contains('oldest')) {
        _sortOption = DATE_ASC;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var isDark = Provider.of<DarkThemeProvider>(context).isDark;
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
          name: widget.name,
          token: widget.token,
          sort: _sortOption),
    );
  }
}

class ListScreenArgs {
  final String listType, name, token;

  ListScreenArgs({@required this.listType, this.name = "", this.token = ""});
}
