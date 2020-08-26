import 'package:flutter/material.dart';
import 'package:rank_ten/components/generic_list_preview_widget.dart';
import 'package:rank_ten/components/user_preview_widget.dart';
import 'package:rank_ten/repos/ranked_list_preview_repository.dart';
import 'package:rank_ten/repos/user_preview_repository.dart';

class SearchTabLists extends StatelessWidget {
  final String query;
  final int sort;
  final bool searchLists;

  const SearchTabLists({Key key, this.query, this.sort, this.searchLists})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return searchLists
        ? Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: GenericListPreviewWidget(
                listType: SEARCH_LISTS, query: query, sort: sort, key: key),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: UserPreviewWidget(
              listType: SEARCH_USERS,
              query: query,
              sort: sort,
              key: key,
            ),
          );
  }
}
