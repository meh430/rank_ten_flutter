import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/misc/app_theme.dart';
import 'package:rank_ten/providers/dark_theme_provider.dart';
import 'package:rank_ten/providers/main_user_provider.dart';

import 'choose_pic.dart';

class RankedListCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainUserProvider userProvider =
        Provider.of<MainUserProvider>(context);
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CardHeader(),
            Text("Best Shows!",
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center),
            SizedBox(height: 10),
            RankItemImage(
                imageUrl:
                    "https://cdn.vox-cdn.com/thumbor/hOagCnRe2cCIIZhcLuJUH5ZPVvk=/0x0:1075x604/1200x800/filters:focal(452x216:624x388)/cdn.vox-cdn.com/uploads/chorus_image/image/66255911/Screen_Shot_2020_02_05_at_9.44.59_AM.0.png"),
            RankPreviewItems(),
            Text("View 7 more items",
                style: Theme.of(context).textTheme.headline6.copyWith(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold)),
            CardFooter(),
            CommentPreviewCard()
          ],
        ),
      ),
    );
  }
}

class CardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isDark = Provider.of<DarkThemeProvider>(context).isDark;
    var textTheme = Theme.of(context)
        .primaryTextTheme
        .headline6
        .copyWith(color: isDark ? white : secondText);
    return Padding(
      padding: EdgeInsets.only(top: 14, left: 14, right: 20, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(children: [
            CircleImage(),
            SizedBox(
              width: 8,
            ),
            Text("Meh4life321", style: textTheme)
          ]),
          Text("2h ago", style: textTheme)
        ],
      ),
    );
  }
}

class CircleImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 60.0,
        height: 60.0,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
                fit: BoxFit.fill,
                image: new NetworkImage("https://i.imgur.com/BoN9kdC.png"))));
  }
}

class RankPreviewItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            margin: EdgeInsets.all(12),
            child: Center(
                child: Text(
              "1",
              textAlign: TextAlign.center,
              style:
                  Theme.of(context).textTheme.headline4.copyWith(color: white),
            )),
            width: 85.0,
            height: 85.0,
            decoration:
                new BoxDecoration(shape: BoxShape.circle, color: lavender)),
        SizedBox(width: 10),
        Expanded(
            child:
                Text("Rank Item", style: Theme.of(context).textTheme.headline4))
      ],
    );
  }
}

class CardFooter extends StatefulWidget {
  @override
  _CardFooterState createState() => _CardFooterState();
}

class _CardFooterState extends State<CardFooter> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 18, bottom: 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.red, size: 60),
            onPressed: () => print("Like"),
          ),
          Column(children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "103 likes",
              style: Theme.of(context).textTheme.headline6,
            )
          ])
        ],
      ),
    );
  }
}

class RankPreviewItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [RankPreviewItem(), RankPreviewItem(), RankPreviewItem()],
    );
  }
}

class CommentPreviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<DarkThemeProvider>(context).isDark;

    return Card(
        color: isDark ? hanPurple : palePurple,
        elevation: 2,
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CardHeader(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "I made.",
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              SizedBox(height: 10),
              Text("View all 22 comments",
                  style: Theme.of(context).textTheme.headline6.copyWith(
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 10)
            ],
          ),
        ));
  }
}
