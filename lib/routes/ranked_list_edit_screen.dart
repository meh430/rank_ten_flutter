import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/blocs/ranked_list_bloc.dart';
import 'package:rank_ten/components/list_future_dialog.dart';
import 'package:rank_ten/components/rank_item_edit_dialog.dart';
import 'package:rank_ten/components/rank_item_view_card.dart';
import 'package:rank_ten/components/ranked_list_card_widget.dart';
import 'package:rank_ten/events/ranked_list_events.dart';
import 'package:rank_ten/misc/app_theme.dart';
import 'package:rank_ten/misc/utils.dart';
import 'package:rank_ten/models/rank_item.dart';
import 'package:rank_ten/models/ranked_list.dart';
import 'package:rank_ten/providers/dark_theme_provider.dart';
import 'package:rank_ten/providers/main_user_provider.dart';
import 'package:rank_ten/repos/ranked_list_repository.dart';

class RankedListEditScreen extends StatefulWidget {
  final String listTitle;
  final int listId;
  final bool isNew;

  const RankedListEditScreen(
      {Key key, this.listId = 0, this.listTitle = "Title", this.isNew = false})
      : super(key: key);

  @override
  _RankedListEditScreenState createState() => _RankedListEditScreenState();
}

Future<bool> showErrorDialog(
    {@required BuildContext context, @required String error}) {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          title: Text(error, style: Theme.of(context).textTheme.headline5),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Ok',
                style: Theme.of(context).textTheme.headline6,
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      });
}

class _RankedListEditScreenState extends State<RankedListEditScreen> {
  RankedListBloc _rankedListBloc;
  bool _isPrivate = false;
  String _listTitle;
  TextEditingController _titleController;
  MainUserProvider userProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<MainUserProvider>(context, listen: false);
    _rankedListBloc = RankedListBloc();
    _rankedListBloc.addEvent(GetRankedListEvent(widget.listId));
    _listTitle = widget.listTitle;
    _titleController = TextEditingController(text: _listTitle);
  }

  Future<bool> _saveList() async {
    if (_titleController.text.isEmpty) {
      return (await showErrorDialog(
              context: context, error: "Title cannot be empty")) ??
          false;
    }

    if (_rankedListBloc.model.rankItems.length < 1) {
      return (await showErrorDialog(
              context: context, error: "List should have at least 1 items")) ??
          false;
    }

    if (widget.isNew) {
      return (await showDialog(
              context: context,
              builder: (context) => ListFuture(
                    listFuture: RankedListRepository().createRankedList(
                        rankedList: _rankedListBloc.model,
                        token: userProvider.jwtToken),
                  ))) ??
          false;
    } else {
      return (await showDialog<bool>(
              context: context,
              builder: (context) => ListFuture(
                    listFuture: RankedListRepository().updateRankedList(
                        rankedList: _rankedListBloc.model,
                        listId: _rankedListBloc.model.listId,
                        token: userProvider.jwtToken),
                  ))) ??
          false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var isDark = Provider.of<DarkThemeProvider>(context, listen: false).isDark;
    return WillPopScope(
      onWillPop: _saveList,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            brightness: isDark ? Brightness.dark : Brightness.light,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            actions: [
              IconButton(
                icon:
                    Icon(_isPrivate ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() => _isPrivate = !_isPrivate);
                  _rankedListBloc.addEvent(RankedListPrivateEvent(_isPrivate));
                },
              ),
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    if (!widget.isNew) {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (context) => ListFuture(
                                listFuture: RankedListRepository()
                                    .deleteRankedList(
                                        listId: widget.listId,
                                        token: userProvider.jwtToken),
                              ));
                    } else {
                      Navigator.pop(context);
                    }
                  })
            ],
            title: TextField(
              style: Theme.of(context).primaryTextTheme.headline5,
              controller: _titleController,
              textInputAction: TextInputAction.done,
              onSubmitted: (value) =>
                  _rankedListBloc.addEvent(RankedListTitleEvent(value)),
            ),
          ),
          body: StreamBuilder<RankedList>(
              stream: _rankedListBloc.modelStateStream,
              builder:
                  (BuildContext context, AsyncSnapshot<RankedList> snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                  List<Widget> listChildren = [];
                  for (int i = 0; i < snapshot.data.rankItems.length; i++) {
                    var rItem = snapshot.data.rankItems[i];
                    listChildren.add(Dismissible(
                      onDismissed: (direction) {
                        _rankedListBloc.addEvent(RankedListItemDeleteEvent(i));
                      },
                      key: ObjectKey(rItem),
                      background: Container(color: Colors.red),
                      child: RankItemViewCard(
                        onTap: () => showRankItemEditDialog(
                            isNew: false,
                            context: context,
                            index: i,
                            rankedListBloc: _rankedListBloc,
                            rankItem: rItem),
                        rankItem: rItem,
                      ),
                    ));
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ReorderableListView(
                            header: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: widget.isNew
                                  ? SizedBox()
                                  : CardHeader(
                                      userId: snapshot.data.userId,
                                      shouldPushInfo: false,
                                      userName: snapshot.data.username,
                                      profPicUrl:
                                          userProvider.mainUser.profilePic,
                                      dateCreated: snapshot.data.dateCreated),
                            ),
                            onReorder: (int oldIndex, int newIndex) {
                              _rankedListBloc.addEvent(RankedListReorderEvent(
                                  previousPosition: oldIndex,
                                  newPosition: newIndex));
                            },
                            children: listChildren),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 2),
                        child: RaisedButton(
                          padding: const EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          color: paraPink,
                          onPressed: () => showRankItemEditDialog(
                            isNew: true,
                            context: context,
                            rankedListBloc: _rankedListBloc,
                          ),
                          child: Icon(Icons.add, color: palePurple),
                        ),
                      )
                    ],
                  );
                } else if (snapshot.hasError) {
                  WidgetsBinding.instance.addPostFrameCallback(
                      (_) => Utils.showSB("Error getting list", context));
                  return Utils.getErrorImage();
                }

                return const SpinKitRipple(size: 50, color: hanPurple);
              })),
    );
  }
}

void showRankItemEditDialog(
    {@required BuildContext context,
    @required RankedListBloc rankedListBloc,
    int index,
    RankItem rankItem,
    @required bool isNew}) {
  showDialog(
      context: context,
      builder: (context) => RankItemEditDialog(
          rankItem: rankItem,
          isNew: isNew,
          rankedListBloc: rankedListBloc,
          index: index));
}

class RankedListEditScreenArgs {
  final String listTitle;
  final bool isNew;
  final int listId;

  RankedListEditScreenArgs(
      {this.listId = 0, this.listTitle = "Title", this.isNew});
}
