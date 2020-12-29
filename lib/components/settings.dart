import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/api/preferences_store.dart';
import 'package:rank_ten/misc/app_theme.dart';
import 'package:rank_ten/providers/dark_theme_provider.dart';
import 'package:rank_ten/providers/main_user_provider.dart';
import 'package:rank_ten/repos/user_repository.dart';

void showSettings(BuildContext context) {
  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15), topLeft: Radius.circular(15))),
      builder: (BuildContext con) {
        return Settings();
      });
}

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isDark;
  DarkThemeProvider _themeProvider;

  @override
  void initState() {
    super.initState();
    _themeProvider = Provider.of<DarkThemeProvider>(context, listen: false);
    _isDark = _themeProvider.isDark;
  }

  void logOut() {
    PreferencesStore.clearAll();
    Navigator.pop(context);
    Navigator.pop(context);
    Provider.of<MainUserProvider>(context, listen: false).logOut();
    Navigator.pushNamed(context, '/login_signup');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Settings", style: Theme.of(context).textTheme.headline5),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Switch(
                value: _isDark,
                onChanged: (value) => setState(() {
                  _isDark = value;
                  _themeProvider.isDark = value;
                }),
                activeTrackColor: lavender,
                activeColor: hanPurple,
              ),
              Text("Toggle dark theme",
                  style: Theme.of(context).textTheme.headline6)
            ],
          ),
          SizedBox(
            height: 8,
          ),
          ActionButton(
            color: hanPurple,
            label: "Log Out",
            onPress: logOut,
          ),
          ActionButton(
            color: Colors.red,
            label: "Delete User",
            onPress: () async {
              String token =
                  Provider.of<MainUserProvider>(context, listen: false)
                      .jwtToken;
              UserRepository().deleteUser(token);
              logOut();
            },
          )
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final Color color;
  final String label;
  final VoidCallback onPress;

  ActionButton({this.color, this.label, this.onPress});

  @override
  Widget build(BuildContext context) {
    print(color);
    return Padding(
      padding: const EdgeInsets.all(4),
      child: RaisedButton(
          color: color,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text(label,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: white)),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          onPressed: onPress),
    );
  }
}
