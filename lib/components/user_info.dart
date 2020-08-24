import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/components/choose_pic.dart';
import 'package:rank_ten/events/user_events.dart';
import 'package:rank_ten/misc/app_theme.dart';
import 'package:rank_ten/models/user.dart';
import 'package:rank_ten/providers/dark_theme_provider.dart';
import 'package:rank_ten/providers/main_user_provider.dart';

import '../misc/utils.dart';
import 'login.dart';

class UserInfo extends StatelessWidget {
  final User user;
  final bool isMain;

  UserInfo({@required this.user, this.isMain = false});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<MainUserProvider>(context);
    Widget profilePic =
        RoundedImage(imageUrl: user.profPic, uInitial: user.userName[0]);
    profilePic = isMain
        ? GestureDetector(
            child: profilePic,
            onTap: () => showProfilePicker(
                context: context,
                url: user.profPic,
                setImage: (String imageUrl) {
                  userProvider.addUserEvent(UpdateProfilePicEvent(
                      profPic: imageUrl, token: userProvider.jwtToken));
                }))
        : profilePic;

    return Card(
      margin: const EdgeInsets.all(10.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //RoundedImage(imageUrl: user.profPic, uInitial: user.userName[0]),
          profilePic,
          UserStatRow(user: user),
          const SizedBox(width: 10)
        ],
      ),
    );
  }
}

class RoundedImage extends StatelessWidget {
  final String imageUrl;
  final String uInitial;

  RoundedImage({@required this.imageUrl, @required this.uInitial});

  @override
  Widget build(BuildContext context) {
    var image = imageUrl != ""
        ? ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              imageUrl,
              height: 130,
              width: 130,
              fit: BoxFit.cover,
            ))
        : getProfilePic(uInitial, context);

    return Padding(
      child: image,
      padding: const EdgeInsets.all(12.0),
    );
  }
}

class UserStat extends StatelessWidget {
  final int statCount;
  final String statLabel;

  UserStat({@required this.statLabel, @required this.statCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          Text(
            statCount.toString(),
            style: Theme.of(context).primaryTextTheme.headline6,
          ),
          Text(statLabel, style: Theme.of(context).textTheme.headline6)
        ],
      ),
    );
  }
}

class UserStatRow extends StatelessWidget {
  final User user;

  UserStatRow({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Column(
          children: [
            UserStat(statLabel: "Rank Points", statCount: user.rankPoints),
            UserStat(statLabel: "Rank Lists", statCount: user.listNum),
          ],
        ),
        const SizedBox(width: 10),
        Column(
          children: [
            UserStat(statLabel: "Following", statCount: user.numFollowing),
            UserStat(statLabel: "Followers", statCount: user.numFollowers)
          ],
        )
      ],
    );
  }
}

class UserBio extends StatelessWidget {
  final User user;
  final bool isMain;

  UserBio({@required this.user, this.isMain = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isMain ? BioEditWidget(bio: user.bio) : BioWidget(bio: user.bio),
            const SizedBox(height: 10),
            Text("Date Created",
                style: Theme
                    .of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: getTitleColor(context))),
            Text(Utils.getDate(user.dateCreated),
                style: Theme
                    .of(context)
                    .textTheme
                    .headline4
                    .copyWith(fontSize: 18))
          ],
        ),
      ),
    );
  }
}

class BioWidget extends StatelessWidget {
  final String bio;

  BioWidget({@required this.bio});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Bio",
          style: Theme
              .of(context)
              .textTheme
              .headline5
              .copyWith(color: getTitleColor(context)),
        ),
        Text(bio,
            style: Theme
                .of(context)
                .textTheme
                .headline4
                .copyWith(fontSize: 18))
      ],
    );
  }
}

class BioEditWidget extends StatefulWidget {
  final String bio;

  BioEditWidget({@required this.bio});

  @override
  _BioEditWidgetState createState() => _BioEditWidgetState();
}

class _BioEditWidgetState extends State<BioEditWidget> {
  String _currBio;
  bool _editing = false;
  TextEditingController _bController;

  @override
  void initState() {
    super.initState();
    setState(() => _currBio = widget.bio);
    _bController = TextEditingController(text: widget.bio);
  }

  Widget getBioEditField() {
    final userProvider = Provider.of<MainUserProvider>(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return TextField(
      onSubmitted: (String value) {
        if (value.isEmpty) {
          Scaffold.of(context).showSnackBar(Utils.getSB('Bio cannot be empty'));
        } else {
          _editing = false;
          userProvider.addUserEvent(
              UpdateBioEvent(bio: value, token: userProvider.jwtToken));
        }
      },
      textInputAction: TextInputAction.done,
      controller: _bController,
      maxLines: null,
      style: TextStyle(color: themeChange.isDark ? white : Colors.black),
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20.0),
          border: getInputStyle(themeChange.isDark),
          enabledBorder: getInputStyle(themeChange.isDark),
          focusedBorder: getInputStyle(themeChange.isDark)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Bio",
              style: Theme
                  .of(context)
                  .textTheme
                  .headline5
                  .copyWith(color: getTitleColor(context)),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => setState(() => _editing = !_editing),
            )
          ],
        ),
        _editing
            ? getBioEditField()
            : Text(_currBio,
            style: Theme
                .of(context)
                .textTheme
                .headline4
                .copyWith(fontSize: 18))
      ],
    );
  }
}

Widget getProfilePic(String uInitial, BuildContext context) {
  return Container(
    width: 130.0,
    height: 130.0,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: Utils.getRandomColor()),
    child: Center(
        child: Text((uInitial ?? "I").toUpperCase(),
            style: Theme
                .of(context)
                .textTheme
                .headline2
                .copyWith(color: Colors.black))),
  );
}

Color getTitleColor(BuildContext context) {
  return Provider
      .of<DarkThemeProvider>(context)
      .isDark ? lavender : hanPurple;
}
