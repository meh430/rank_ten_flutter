import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/components/generic_list_preview_widget.dart';
import 'package:rank_ten/providers/main_user_provider.dart';
import 'package:rank_ten/repos/ranked_list_preview_repository.dart';

class FeedTab extends StatelessWidget {
  final int sort;

  FeedTab({Key key, this.sort}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var followingNum =
        Provider.of<MainUserProvider>(context).mainUser.numFollowing;

    return GenericListPreviewWidget(
        listType: FEED_LISTS,
        emptyMessage: followingNum == 0
            ? "Follow people to see their lists here"
            : "No lists posted in the last 24 hours",
        sort: sort,
        token: Provider.of<MainUserProvider>(context).jwtToken,
        key: key);
  }
}
