import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/components/generic_list_preview_widget.dart';
import 'package:rank_ten/providers/main_user_provider.dart';
import 'package:rank_ten/repos/ranked_list_preview_repository.dart';

class FeedTab extends StatelessWidget {
  final int sort;

  FeedTab({this.sort});

  @override
  Widget build(BuildContext context) {
    return GenericListPreviewWidget(
      listType: FEED_LISTS,
      sort: sort,
      token: Provider.of<MainUserProvider>(context).jwtToken,
    );
  }
}
