import 'package:flutter/material.dart';
import 'package:rank_ten/components/generic_list_preview_widget.dart';
import 'package:rank_ten/repos/ranked_list_preview_repository.dart';

class DiscoverTab extends StatelessWidget {
  final int sort;

  DiscoverTab({this.sort});

  @override
  Widget build(BuildContext context) {
    return GenericListPreviewWidget(listType: DISCOVER_LISTS, sort: sort);
  }
}
