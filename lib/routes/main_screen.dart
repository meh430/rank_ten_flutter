import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/misc/app_theme.dart';
import 'package:rank_ten/misc/utils.dart';
import 'package:rank_ten/providers/dark_theme_provider.dart';
import 'package:rank_ten/providers/main_user_provider.dart';
import 'package:rank_ten/tabs/discover_tab.dart';
import 'package:rank_ten/tabs/feed_tab.dart';
import 'package:rank_ten/tabs/profile_tab.dart';

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
  int _sortOption = LIKES_DESC;
  String _query = "";
  List<Widget> _destinations = [];

  @override
  void initState() {
    super.initState();
    _appBarTitles.add(Provider.of<MainUserProvider>(context, listen: false)
        .mainUser
        .userName);

    _destinations.add(FeedTab(sort: _sortOption));
    _destinations.add(DiscoverTab(sort: _sortOption));
    _destinations.add(getTempDest(2));
    _destinations.add(ProfileTab());
  }

  void _onItemTapped(int index) {
    setState(() {
      _currIndex = index;
    });
  }

  void _sortCallback(String option) {
    final prevIndex = _currIndex;
    print(option);
    setState(() {
      if (option.contains("like")) {
        _sortOption = LIKES_DESC;
      } else if (option.contains("newest")) {
        _sortOption = DATE_DESC;
      } else if (option.contains("oldest")) {
        _sortOption = DATE_ASC;
      }

      //_destinations[0] = FeedTab(sort: _sortOption);
      //_destinations[1] = DiscoverTab(sort: _sortOption);
      _currIndex = 3;
    });

    Future.delayed(Duration(milliseconds: 15),
        () => setState(() => _currIndex = prevIndex));
  }

  void _searchCallback(String query) {
    print("query: $query");
    setState(() {
      _query = query;
    });
  }

  Color getTabItemColor(int index) {
    return index == _currIndex ? hanPurple : lavender;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: _currIndex == 2
              ? SearchAppBar(
                  sortCallback: _sortCallback, searchCallback: _searchCallback)
              : MainAppBar(
                  sortCallback: _sortCallback,
                  index: _currIndex,
                )),
      body: CurrentTab(sort: _sortOption, query: _query, index: _currIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: paraPink,
        tooltip: 'Add',
        child: const Icon(Icons.add, size: 35),
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
                padding: const EdgeInsets.all(10),
                child: IconButton(
                    color: getTabItemColor(0),
                    onPressed: () => _onItemTapped(0),
                    icon: const Icon(Icons.list),
                    iconSize: 35)),
            Padding(
                padding: const EdgeInsets.only(right: 40, top: 10, bottom: 10),
                child: IconButton(
                    color: getTabItemColor(1),
                    onPressed: () => _onItemTapped(1),
                    icon: const Icon(Icons.navigation),
                    iconSize: 35)),
            Padding(
                padding: const EdgeInsets.only(left: 40, top: 10, bottom: 10),
                child: IconButton(
                    color: getTabItemColor(2),
                    onPressed: () => _onItemTapped(2),
                    icon: const Icon(Icons.search),
                    iconSize: 35)),
            Padding(
                padding: const EdgeInsets.all(10),
                child: IconButton(
                    color: getTabItemColor(3),
                    onPressed: () => _onItemTapped(3),
                    icon: const Icon(Icons.account_circle),
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
  final sortCallback;

  MainAppBar({this.index, this.sortCallback});

  @override
  _MainAppBarState createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  bool isDark;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    isDark = themeChange.isDark;

    var action;

    if (widget.index == 0 || widget.index == 1) {
      action = getSortAction(
          context: context, isDark: isDark, sortCallback: widget.sortCallback);
    } else if (widget.index == 3) {
      action = IconButton(
        icon: Icon(themeChange.isDark ? Icons.brightness_5 : Icons.brightness_2,
            color: themeChange.isDark ? lavender : Colors.yellow),
        onPressed: () {
          setState(() => themeChange.isDark = !themeChange.isDark);
        },
      );
    }

    return AppBar(
      toolbarHeight: 70,
      automaticallyImplyLeading: false,
      elevation: 0.0,
      brightness: isDark ? Brightness.dark : Brightness.light,
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      actions: [action],
      title: Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 12.0),
          child: Text(_appBarTitles[widget.index],
              style: Theme
                  .of(context)
                  .primaryTextTheme
                  .headline3)),
    );
  }
}

class SearchAppBar extends StatefulWidget {
  final sortCallback, searchCallback;

  SearchAppBar({this.sortCallback, this.searchCallback});

  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  var _searchController = TextEditingController();
  var _searching = false;

  @override
  Widget build(BuildContext context) {
    var isDark = Provider
        .of<DarkThemeProvider>(context)
        .isDark;

    return AppBar(
      toolbarHeight: 70,
      elevation: 0.0,
      brightness: isDark ? Brightness.dark : Brightness.light,
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      actions: [
        getSortAction(
            context: context, isDark: isDark, sortCallback: widget.sortCallback)
      ],
      leading: Icon(Icons.search, color: isDark ? lavender : darkSienna),
      title: _searching
          ? TextField(
        controller: _searchController,
        style: Theme
            .of(context)
            .textTheme
            .headline6,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
            hintText: "Search...",
            hintStyle: Theme
                .of(context)
                .textTheme
                .headline6
                .copyWith(color: secondText)),
        onSubmitted: (value) => widget.searchCallback(value),
      )
          : GestureDetector(
        onTap: () => setState(() => _searching = true),
        child: Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 12.0),
            child: Text("Search",
                style: Theme
                    .of(context)
                    .primaryTextTheme
                    .headline3)),
      ),
    );
  }
}

Widget getSortAction(
    {BuildContext context, bool isDark, dynamic sortCallback}) {
  return IconButton(
    icon: Icon(Icons.sort, color: isDark ? lavender : darkSienna),
    onPressed: () {
      showModalBottomSheet<void>(
          isDismissible: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30))),
          context: context,
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getSortOption(
                    context: context,
                    title: "Sort by likes",
                    sortCallback: sortCallback),
                getSortOption(
                    context: context,
                    title: "Sort by newest",
                    sortCallback: sortCallback),
                getSortOption(
                    context: context,
                    title: "Sort by oldest",
                    sortCallback: sortCallback)
              ],
            );
          });
    },
  );
}

Widget getSortOption(
    {BuildContext context, String title, dynamic sortCallback}) {
  return GestureDetector(
    child: ListTile(
      title: Text(title, style: Theme
          .of(context)
          .textTheme
          .headline5),
      contentPadding:
      const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 10),
    ),
    onTap: () {
      sortCallback(title);
      Navigator.pop(context);
    },
  );
}

class CurrentTab extends StatelessWidget {
  final int sort, index;
  final String query;

  CurrentTab({this.sort, this.index, this.query});

  @override
  Widget build(BuildContext context) {
    if (index == 0) {
      return FeedTab(sort: sort);
    } else if (index == 1) {
      return DiscoverTab(sort: sort);
    } else if (index == 2) {
      return getTempDest(2);
    }

    return ProfileTab();
  }
}

