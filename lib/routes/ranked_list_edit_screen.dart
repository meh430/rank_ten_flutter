import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/blocs/ranked_list_bloc.dart';
import 'package:rank_ten/components/rank_item_edit_dialog.dart';
import 'package:rank_ten/components/rank_item_view_card.dart';
import 'package:rank_ten/components/ranked_list_card_widget.dart';
import 'package:rank_ten/events/ranked_list_events.dart';
import 'package:rank_ten/misc/app_theme.dart';
import 'package:rank_ten/models/rank_item.dart';
import 'package:rank_ten/models/ranked_list.dart';
import 'package:rank_ten/providers/dark_theme_provider.dart';
import 'package:rank_ten/providers/main_user_provider.dart';
import 'package:rank_ten/routes/ranked_list_view_screen.dart';

class RankedListEditScreen extends StatefulWidget {
  final String listId, listTitle;
  final bool isNew;

  const RankedListEditScreen(
      {Key key, this.listId = "", this.listTitle = "Title", this.isNew = false})
      : super(key: key);

  @override
  _RankedListEditScreenState createState() => _RankedListEditScreenState();
}

class _RankedListEditScreenState extends State<RankedListEditScreen> {
  RankedListBloc _rankedListBloc;

  @override
  void initState() {
    super.initState();
    _rankedListBloc = RankedListBloc();
    _rankedListBloc.modelEventSink.add(GetRankedListEvent(widget.listId));
  }

  @override
  Widget build(BuildContext context) {
    var isDark = Provider.of<DarkThemeProvider>(context, listen: false).isDark;
    var userProvider = Provider.of<MainUserProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          brightness: isDark ? Brightness.dark : Brightness.light,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(widget.listTitle,
              style: Theme.of(context).primaryTextTheme.headline5),
        ),
        body: StreamBuilder<RankedList>(
            stream: _rankedListBloc.modelStateStream,
            builder:
                (BuildContext context, AsyncSnapshot<RankedList> snapshot) {
              if (snapshot.hasData) {
                List<Widget> listChildren = [];
                for (int i = 0; i < snapshot.data.rankList.length; i++) {
                  var rItem = snapshot.data.rankList[i];
                  listChildren.add(Dismissible(
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
                            child: CardHeader(
                                shouldPushInfo: false,
                                userName: snapshot.data.userName,
                                profPicUrl: userProvider.mainUser.profPic,
                                dateCreated: snapshot.data.dateCreated),
                          ),
                          onReorder: (int oldIndex, int newIndex) {
                            _rankedListBloc.modelEventSink.add(
                                RankedListReorderEvent(
                                    previousPosition: oldIndex,
                                    newPosition: newIndex));
                          },
                          children: listChildren),
                    ),
                    RankListBottomBar(
                      rankedList: snapshot.data,
                    )
                  ],
                );
              }

              return SpinKitRipple(size: 50, color: hanPurple);
                }));
  }
}

void showRankItemEditDialog({@required BuildContext context,
  @required RankedListBloc rankedListBloc,
  int index,
  RankItem rankItem,
  @required bool isNew}) {
  showDialog(
      context: context,
      builder: (context) =>
          RankItemEditDialog(
              rankItem: rankItem,
              isNew: isNew,
              rankedListBloc: rankedListBloc,
              index: index));
}

class RankedListEditScreenArgs {
  final String listId, listTitle;
  final bool isNew;

  RankedListEditScreenArgs({this.listId, this.listTitle, this.isNew});
}
