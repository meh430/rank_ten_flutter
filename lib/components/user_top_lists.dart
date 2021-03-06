import 'package:flutter/material.dart';
import 'package:rank_ten/components/ranked_list_card_widget.dart';

class UserTopLists extends StatelessWidget {
  final topLists;
  final String name;

  UserTopLists({Key key, @required this.topLists, @required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (topLists.length == 0) {
      return Center(
          child: Text(
        "$name has not made any lists",
        style: Theme.of(context).textTheme.headline5,
        textAlign: TextAlign.center,
      ));
    }

    var rankCards = <Widget>[];
    topLists.forEach((listCard) => rankCards.add(RankedListCardWidget(
        listCard: listCard, shouldPushInfo: false, key: ObjectKey(listCard))));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: rankCards,
    );
  }
}
