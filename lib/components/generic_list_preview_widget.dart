import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rank_ten/blocs/preview_lists_bloc.dart';
import 'package:rank_ten/components/ranked_list_card_widget.dart';
import 'package:rank_ten/events/ranked_list_preview_events.dart';
import 'package:rank_ten/misc/app_theme.dart';
import 'package:rank_ten/models/ranked_list_card.dart';

class GenericListPreviewWidget extends StatefulWidget {
  final int sort;
  final String name, token, query, listType;

  const GenericListPreviewWidget(
      {this.sort = 0,
      this.name = "",
      this.token = "",
      this.query = "",
      @required this.listType});

  @override
  _GenericListPreviewWidgetState createState() =>
      _GenericListPreviewWidgetState();
}

class _GenericListPreviewWidgetState extends State<GenericListPreviewWidget> {
  PreviewListsBloc _listsBloc;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _listsBloc = PreviewListsBloc(endpointBase: widget.listType);
    _listsBloc.listEventSink.add(RankedListPreviewEvent(
        sort: widget.sort,
        name: widget.name,
        token: widget.token,
        query: widget.query));
    _scrollController = ScrollController()..addListener(_onScrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _listsBloc.dispose();
  }

  void _onScrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!_listsBloc.hitMax) {
        _listsBloc.listEventSink.add(RankedListPreviewEvent(
            sort: widget.sort,
            name: widget.name,
            token: widget.token,
            query: widget.query));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RankedListCard>>(
      stream: _listsBloc.listStateStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<RankedListCard>> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return RefreshIndicator(
            onRefresh: () {
              return Future.delayed(Duration(milliseconds: 0), () {
                _listsBloc.listEventSink.add(RankedListPreviewEvent(
                    sort: widget.sort,
                    name: widget.name,
                    token: widget.token,
                    query: widget.query,
                    refresh: true));
              });
            },
            child: ListView.builder(
                shrinkWrap: false,
                physics: const BouncingScrollPhysics(
                    parent: const AlwaysScrollableScrollPhysics()),
                controller: _scrollController,
                itemCount: snapshot.data.length + 1,
                itemBuilder: (context, index) {
                  if (index >= snapshot.data.length && !_listsBloc.hitMax) {
                    return SpinKitRipple(size: 50, color: hanPurple);
                  } else if (index >= snapshot.data.length) {
                    return SizedBox();
                  }

                  return RankedListCardWidget(listCard: snapshot.data[index]);
                }),
          );
        } else if (snapshot.hasError) {
          return Text("Error retrieving items...");
        }

        return SpinKitRipple(size: 50, color: hanPurple);
      },
    );
  }
}
