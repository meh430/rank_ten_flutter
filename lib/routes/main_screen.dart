import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/api/preferences_store.dart';
import 'package:rank_ten/components/settings.dart';
import 'package:rank_ten/misc/app_theme.dart';
import 'package:rank_ten/misc/utils.dart';
import 'package:rank_ten/providers/dark_theme_provider.dart';
import 'package:rank_ten/providers/main_user_provider.dart';
import 'package:rank_ten/routes/ranked_list_edit_screen.dart';
import 'package:rank_ten/tabs/discover_tab.dart';
import 'package:rank_ten/tabs/feed_tab.dart';
import 'package:rank_ten/tabs/profile_tab.dart';
import 'package:rank_ten/tabs/search_tab.dart';

var _appBarTitles = ["Feed", "Discover", "Search"];

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  int _currIndex = 0;
  int _sortOption = PreferencesStore.currentSort;
  String _query = "";

  TabController _searchTabController;

  @override
  void initState() {
    super.initState();
    _appBarTitles.add(Provider.of<MainUserProvider>(context, listen: false)
        .mainUser
        .username);
    _searchTabController = TabController(length: 2, vsync: this);
  }

  void _onItemTapped(int index) {
    setState(() {
      _currIndex = index;
    });
  }

  void _sortCallback(int option) {
    PreferencesStore.saveSort(option);
    setState(() {
      _sortOption = option;
    });
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
      resizeToAvoidBottomInset: true,
      appBar: _currIndex == 2
          ? PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: SearchAppBar(
                  sortCallback: _sortCallback,
                  searchCallback: _searchCallback,
                  tabController: _searchTabController),
            )
          : PreferredSize(
              preferredSize: Size.fromHeight(55),
              child: MainAppBar(
                sortCallback: _sortCallback,
                index: _currIndex,
              ),
            ),
      body: CurrentTab(
          key: UniqueKey(),
          sort: _sortOption,
          query: _query,
          index: _currIndex,
          tabController: _searchTabController),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/ranked_list_edit',
              arguments: RankedListEditScreenArgs(isNew: true));
        },
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

    if (widget.index == 1) {
      action = getSortAction(
          context: context, isDark: isDark, sortCallback: widget.sortCallback);
    } else if (widget.index == 3) {
      // TODO: settings dialog
      /*action = IconButton(
        icon: Icon(themeChange.isDark ? Icons.brightness_5 : Icons.brightness_2,
            color: themeChange.isDark ? lavender : Colors.yellow),
        onPressed: () {
          setState(() => themeChange.isDark = !themeChange.isDark);
        },
      );*/
      action = IconButton(
        icon: Icon(Icons.settings,
            color: themeChange.isDark ? Colors.white : Colors.black),
        onPressed: () {
          showSettings(context);
        },
      );
    }

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0.0,
      brightness: isDark ? Brightness.dark : Brightness.light,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      actions: action != null ? [action] : null,
      title: Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 12.0),
          child: Text(
              widget.index == 3
                  ? Provider.of<MainUserProvider>(context, listen: false)
                      .mainUser
                      .username
                  : _appBarTitles[widget.index],
              style: Theme.of(context).primaryTextTheme.headline5)),
    );
  }
}

class SearchAppBar extends StatefulWidget {
  final sortCallback, searchCallback;
  final TabController tabController;

  SearchAppBar({this.sortCallback, this.searchCallback, this.tabController});

  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  var _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var isDark = Provider.of<DarkThemeProvider>(context).isDark;

    return AppBar(
        elevation: 0.0,
        brightness: isDark ? Brightness.dark : Brightness.light,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          getSortAction(
              context: context,
              isDark: isDark,
              isUser: widget.tabController.index == 1,
              sortCallback: widget.sortCallback)
        ],
        leading: Icon(Icons.search, color: isDark ? lavender : darkSienna),
        bottom: TabBar(
          controller: widget.tabController,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Theme.of(context).accentColor,
          tabs: [
            Tab(
              text: 'Lists',
            ),
            Tab(
              text: 'People',
            ),
          ],
        ),
        title: TextField(
          controller: _searchController,
          style: Theme.of(context).textTheme.headline6,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: secondText)),
              hintText: "Search...",
              hintStyle: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: secondText)),
          onSubmitted: (value) => widget.searchCallback(value),
        ));
  }
}

Widget getSortAction(
    {@required BuildContext context,
    @required bool isDark,
    @required dynamic sortCallback,
    bool isUser = false}) {
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
                    title: isUser ? "Sort by points" : "Sort by likes",
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
      title: Text(title, style: Theme.of(context).textTheme.headline5),
      contentPadding:
          const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 10),
    ),
    onTap: () {
      var chosenSort = 0;
      if (title.contains("like")) {
        chosenSort = LIKES_DESC;
      } else if (title.contains("newest")) {
        chosenSort = DATE_DESC;
      } else if (title.contains("oldest")) {
        chosenSort = DATE_ASC;
      }

      sortCallback(chosenSort);
      Navigator.pop(context);
    },
  );
}

class CurrentTab extends StatelessWidget {
  final int sort, index;
  final String query;
  final TabController tabController;

  CurrentTab({this.sort, this.index, this.query, this.tabController, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (index == 0) {
      return FeedTab(
        sort: sort,
        key: UniqueKey(),
      );
    } else if (index == 1) {
      return DiscoverTab(
        sort: sort,
        key: UniqueKey(),
      );
    } else if (index == 2) {
      return TabBarView(
        controller: tabController,
        key: UniqueKey(),
        children: [
          SearchTabLists(
            query: query,
            sort: sort,
            searchLists: true,
            key: UniqueKey(),
          ),
          SearchTabLists(
            query: query,
            sort: sort,
            searchLists: false,
            key: UniqueKey(),
          )
        ],
      );
    }

    return ProfileTab();
  }
}
