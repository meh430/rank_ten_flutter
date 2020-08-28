import 'package:flutter/material.dart';
import 'package:rank_ten/misc/app_theme.dart';
import 'package:rank_ten/models/rank_item.dart';

import 'choose_pic.dart';

class RankItemViewCard extends StatelessWidget {
  final RankItem rankItem;

  const RankItemViewCard({Key key, @required this.rankItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 12),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10, top: 10),
                  child: RankCircle(
                    rank: rankItem.rank,
                    margin: 0,
                    size: 50,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      rankItem.itemName,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.headline4,
                    ),
                  ),
                ),
              ],
            ),
            rankItem.picture.isNotEmpty
                ? RankItemImage(
                    imageUrl: rankItem.picture,
                    fit: BoxFit.scaleDown,
                  )
                : SizedBox(),
            rankItem.description.isNotEmpty
                ? Text(rankItem.description, style: textTheme.headline6)
                : SizedBox()
          ],
        ),
      ),
    );
  }
}

class RankCircle extends StatelessWidget {
  final int rank;
  final double size, margin;

  const RankCircle(
      {Key key, @required this.rank, this.size = 85, this.margin = 12})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(margin),
        child: Center(
            child: Text(
          rank.toString(),
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(color: white, fontSize: size / 2),
        )),
        width: size,
        height: size,
        decoration: new BoxDecoration(shape: BoxShape.circle, color: lavender));
  }
}
