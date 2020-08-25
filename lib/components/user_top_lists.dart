import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rank_ten/blocs/preview_lists_bloc.dart';
import 'package:rank_ten/components/ranked_list_card_widget.dart';
import 'package:rank_ten/events/ranked_list_preview_events.dart';
import 'package:rank_ten/misc/app_theme.dart';
import 'package:rank_ten/models/ranked_list_card.dart';
import 'package:rank_ten/repos/ranked_list_preview_repository.dart';

class UserTopLists extends StatefulWidget {
  final String name;
  final bool refresh;

  UserTopLists({@required this.name, this.refresh, Key key}) : super(key: key);

  @override
  _UserTopListsState createState() => _UserTopListsState();
}

class _UserTopListsState extends State<UserTopLists> {
  PreviewListsBloc _listsBloc;

  @override
  void initState() {
    super.initState();
    _listsBloc = PreviewListsBloc(endpointBase: USER_TOP_LISTS);
    _listsBloc.listEventSink.add(
        RankedListPreviewEvent(name: widget.name, refresh: widget.refresh));
  }

  @override
  void dispose() {
    super.dispose();
    _listsBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RankedListCard>>(
      stream: _listsBloc.listStateStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<RankedListCard>> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          if (snapshot.data.length == 0) {
            return Text("${widget.name} has not made any lists");
          }

          var rankCards = <Widget>[];
          snapshot.data.forEach((listCard) =>
              rankCards.add(RankedListCardWidget(listCard: listCard)));
          return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Text("${widget.name}'s Top Lists",
                        style: Theme.of(context).textTheme.headline4)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: rankCards,
                ),
              ]);
          /*return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length-1,
              itemBuilder: (context, index) {
                return RankedListCardWidget(listCard: snapshot.data[index]);
              });*/
        } else if (snapshot.hasError) {
          return Text("Error retrieving items...");
        }

        return SpinKitRipple(size: 50, color: hanPurple);
      },
    );
  }
}
