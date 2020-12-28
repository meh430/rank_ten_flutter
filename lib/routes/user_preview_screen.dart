import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/components/user_preview_widget.dart';
import 'package:rank_ten/providers/dark_theme_provider.dart';
import 'package:rank_ten/repos/user_preview_repository.dart';

class UserPreviewScreen extends StatefulWidget {
  final String listType, username;
  final int id;

  UserPreviewScreen({Key key, @required this.listType, this.username, this.id})
      : super(key: key);

  @override
  _UserPreviewScreenState createState() => _UserPreviewScreenState();
}

class _UserPreviewScreenState extends State<UserPreviewScreen> {
  String appBarTitle = "Lists";

  @override
  void initState() {
    super.initState();
    appBarTitle =
        "${widget.username}'s ${widget.listType == FOLLOWING_USERS ? 'following' : 'followers'}";
  }

  @override
  Widget build(BuildContext context) {
    var isDark = Provider.of<DarkThemeProvider>(context, listen: false).isDark;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        brightness: isDark ? Brightness.dark : Brightness.light,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(appBarTitle,
            style: Theme.of(context).primaryTextTheme.headline5),
      ),
      body: UserPreviewWidget(
          key: UniqueKey(), listType: widget.listType, id: widget.id),
    );
  }
}

class UserPreviewScreenArgs {
  final String listType, username;
  final int id;

  UserPreviewScreenArgs({@required this.listType, this.username = "", this.id});
}
