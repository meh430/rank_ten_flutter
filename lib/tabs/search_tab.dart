import 'package:flutter/material.dart';
import 'package:rank_ten/components/generic_list_preview_widget.dart';
import 'package:rank_ten/repos/ranked_list_preview_repository.dart';

class SearchTabLists extends StatelessWidget {
  final String query;
  final int sort;
  final bool searchLists;

  const SearchTabLists({Key key, this.query, this.sort, this.searchLists})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return searchLists
        ? GenericListPreviewWidget(
            listType: SEARCH_LISTS, query: query, sort: sort, key: key)
        : Text(query);
  }
}
