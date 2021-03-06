import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/components/ranked_list_card_widget.dart';
import 'package:rank_ten/misc/app_theme.dart';
import 'package:rank_ten/models/user.dart';
import 'package:rank_ten/providers/dark_theme_provider.dart';
import 'package:rank_ten/routes/user_info_screen.dart';

class UserPreviewCard extends StatelessWidget {
  final UserPreview userPreview;

  UserPreviewCard({Key key, this.userPreview}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDark = Provider.of<DarkThemeProvider>(context, listen: false).isDark;
    Widget profPic = Padding(
      padding: const EdgeInsets.all(10),
      child: CircleImage(
        profilePic: userPreview.profilePic,
        username: userPreview.username,
        size: 80,
        textSize: 40,
      ),
    );

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/user_info_screen',
          arguments: UserInfoScreenArgs(
              username: userPreview.username, userId: userPreview.userId)),
      child: Card(
          elevation: 4,
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  profPic,
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userPreview.username,
                        style: Theme.of(context).textTheme.headline5,
                        textAlign: TextAlign.start,
                      ),
                      Text("Rank Points: ${userPreview.rankPoints}",
                          style: Theme.of(context).textTheme.headline6,
                          textAlign: TextAlign.start)
                    ],
                  )
                ],
              ),
              userPreview.bio.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 3, bottom: 12),
                      child: Text(userPreview.bio,
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              color: isDark ? Colors.white : secondText)),
                    )
                  : SizedBox()
            ],
          )),
    );
  }
}
