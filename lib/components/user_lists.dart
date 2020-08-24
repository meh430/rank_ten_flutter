import 'package:flutter/material.dart';
import 'package:rank_ten/components/generic_list_preview_widget.dart';
import 'package:rank_ten/misc/utils.dart';
import 'package:rank_ten/repos/ranked_list_preview_repository.dart';

class UserLists extends StatefulWidget {
  @override
  _UserListsState createState() => _UserListsState();
}

class _UserListsState extends State<UserLists> {
  @override
  Widget build(BuildContext context) {
    return GenericListPreviewWidget(
        listType: USER_LISTS, sort: DATE_DESC, name: "meh4life");
  }
}
