import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/blocs/ranked_list_bloc.dart';
import 'package:rank_ten/components/login.dart';
import 'package:rank_ten/events/ranked_list_events.dart';
import 'package:rank_ten/misc/app_theme.dart';
import 'package:rank_ten/models/rank_item.dart';
import 'package:rank_ten/providers/dark_theme_provider.dart';

import 'choose_pic.dart';

class RankItemEditDialog extends StatefulWidget {
  final RankItem rankItem;
  final RankedListBloc rankedListBloc;
  final int index;
  final bool isNew;

  RankItemEditDialog(
      {Key key, this.rankItem, this.isNew, this.rankedListBloc, this.index})
      : super(key: key);

  @override
  _RankItemEditDialogState createState() => _RankItemEditDialogState();
}

class _RankItemEditDialogState extends State<RankItemEditDialog> {
  TextEditingController _nameController;
  TextEditingController _descController;
  TextEditingController _urlController;
  bool validImage = false, validName = true;
  String imageUrl = "";

  void _setValid(bool valid) {
    validImage = valid;
  }

  @override
  void initState() {
    super.initState();
    if (!widget.isNew) {
      imageUrl = widget.rankItem.picture;
      _nameController = widget.rankItem.itemName.isNotEmpty
          ? TextEditingController(text: widget.rankItem.itemName)
          : TextEditingController();
      _descController = widget.rankItem.description.isNotEmpty
          ? TextEditingController(text: widget.rankItem.description)
          : TextEditingController();
      _urlController = imageUrl.isNotEmpty
          ? TextEditingController(text: imageUrl)
          : TextEditingController();
    } else {
      _nameController = TextEditingController();
      _descController = TextEditingController();
      _urlController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var isDark = Provider.of<DarkThemeProvider>(context, listen: false).isDark;
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      widget.isNew ? "Create Item" : "Edit Item",
                      style: textTheme.headline5,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  PreviewImage(
                      imageValid: _setValid,
                      imageUrl: imageUrl,
                      profilePicker: false),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                        textInputAction: TextInputAction.done,
                        onSubmitted: (value) =>
                            setState(() => imageUrl = value),
                        style: textTheme.headline6.copyWith(fontSize: 16),
                        controller: _urlController,
                        onChanged: (value) => setState(() => imageUrl = value),
                        decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              dragStartBehavior: DragStartBehavior.down,
                              onTap: () => _urlController.clear(),
                              child: Icon(Icons.clear,
                                  color: isDark ? palePurple : Colors.black,
                                  semanticLabel: 'Clear URL'),
                            ),
                            labelText: 'Image URL',
                            contentPadding: const EdgeInsets.all(20.0),
                            labelStyle:
                                textTheme.headline6.copyWith(fontSize: 16),
                            border: getInputStyle(isDark),
                            enabledBorder: getInputStyle(isDark),
                            focusedBorder: getInputStyle(isDark))),
                  ),
                  const SizedBox(height: 10),
                  _buildEditField(
                      controller: _nameController,
                      key: ValueKey("ItemName$validName"),
                      isDark: isDark,
                      context: context,
                      errorText: validName ? null : "Name cannot by empty",
                      label: "Item Name"),
                  _buildEditField(
                      controller: _descController,
                      key: ValueKey("Description"),
                      isDark: isDark,
                      context: context,
                      label: "Description"),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: buildDialogButton(
                        onPressed: () {
                          var itemName = _nameController.text;
                          var description = _descController.text;

                          if (itemName.isEmpty) {
                            setState(() => validName = false);
                            return;
                          } else {
                            setState(() => validName = true);
                          }

                          if (widget.isNew) {
                            widget.rankedListBloc.modelEventSink.add(
                                RankedListItemCreateEvent(
                                    itemName: itemName,
                                    itemDescription: description,
                                    imageUrl: validImage ? imageUrl : ""));
                          } else {
                            widget.rankedListBloc.modelEventSink.add(
                                RankedListItemUpdateEvent(
                                    itemName: itemName,
                                    itemDescription: description,
                                    imageUrl: validImage ? imageUrl : "",
                                    index: widget.index));
                          }
                          Navigator.pop(context);
                        },
                        context: context,
                        label: "Save Item"),
                  )
                ],
              ),
            )));
  }
}

Widget _buildEditField(
    {@required BuildContext context,
    @required TextEditingController controller,
    @required bool isDark,
    @required String label,
    Key key,
    String errorText}) {
  return Padding(
    key: key,
    padding: const EdgeInsets.all(12),
    child: TextField(
        textInputAction: TextInputAction.done,
        style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 16),
        controller: controller,
        maxLines: null,
        decoration: InputDecoration(
            errorText: errorText,
            labelText: label,
            contentPadding: const EdgeInsets.all(20.0),
            labelStyle:
                Theme.of(context).textTheme.headline6.copyWith(fontSize: 16),
            border: getInputStyle(isDark),
            enabledBorder: getInputStyle(isDark),
            focusedBorder: getInputStyle(isDark))),
  );
}
