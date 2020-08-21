import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/app_theme.dart';
import 'package:rank_ten/dark_theme_provider.dart';
import 'package:rank_ten/main_user_provider.dart';
import 'package:rank_ten/profile_tab.dart';

var _appBarTitles = ["Feed", "Discover", "Search"];

Center getTempDest(int index) {
  return Center(
    child: Text(_appBarTitles[index]),
  );
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currIndex = 0;
  List<Widget> _destinations = List.generate(3, (index) => getTempDest(index));

  @override
  void initState() {
    super.initState();
    _appBarTitles.add(Provider.of<MainUserProvider>(context, listen: false)
        .mainUser
        .userName);
    _destinations.add(ProfileTab());
  }

  void _onItemTapped(int index) {
    setState(() {
      _currIndex = index;
    });
  }

  Color getTabItemColor(int index) {
    return index == _currIndex ? hanPurple : lavender;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: MainAppBar(
            index: _currIndex,
          )),
      body: _destinations[_currIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: paraPink,
        tooltip: 'Add',
        child: Icon(Icons.add, size: 35),
        elevation: 4.0,
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 20.0,
        notchMargin: 12.0,
        shape: CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(10),
                child: IconButton(
                    color: getTabItemColor(0),
                    onPressed: () => _onItemTapped(0),
                    icon: Icon(Icons.list),
                    iconSize: 35)),
            Padding(
                padding: EdgeInsets.only(right: 40, top: 10, bottom: 10),
                child: IconButton(
                    color: getTabItemColor(1),
                    onPressed: () => _onItemTapped(1),
                    icon: Icon(Icons.navigation),
                    iconSize: 35)),
            Padding(
                padding: EdgeInsets.only(left: 40, top: 10, bottom: 10),
                child: IconButton(
                    color: getTabItemColor(2),
                    onPressed: () => _onItemTapped(2),
                    icon: Icon(Icons.search),
                    iconSize: 35)),
            Padding(
                padding: EdgeInsets.all(10),
                child: IconButton(
                    color: getTabItemColor(3),
                    onPressed: () => _onItemTapped(3),
                    icon: Icon(Icons.account_circle),
                    iconSize: 35))
          ],
        ),
        color: Theme.of(context).cardColor,
      ),
    );
  }
}

class MainAppBar extends StatefulWidget {
  final int index;

  MainAppBar({this.index});

  @override
  _MainAppBarState createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  bool isDark;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return AppBar(
      toolbarHeight: 70,
      elevation: 0.0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      actions: [
        IconButton(
          icon: Icon(
              themeChange.isDark ? Icons.brightness_5 : Icons.brightness_2,
              color: themeChange.isDark ? lavender : Colors.yellow),
          onPressed: () {
            setState(() => themeChange.isDark = !themeChange.isDark);
          },
        )
      ],
      title: Padding(
          padding: EdgeInsets.only(left: 12.0, top: 12.0),
          child: Text(_appBarTitles[widget.index],
              style: Theme.of(context).primaryTextTheme.headline3)),
    );
  }
}
