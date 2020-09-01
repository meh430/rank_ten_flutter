import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rank_ten/blocs/user_preview_bloc.dart';
import 'package:rank_ten/components/user_preview_card.dart';
import 'package:rank_ten/events/user_preview_events.dart';
import 'package:rank_ten/misc/app_theme.dart';
import 'package:rank_ten/models/user.dart';
import 'package:rank_ten/repos/user_preview_repository.dart';

class UserPreviewWidget extends StatefulWidget {
  final int sort;
  final String name, query, listType, emptyMessage;

  const UserPreviewWidget(
      {this.sort = 0,
      this.name = "",
      this.query = "",
      this.emptyMessage = 'No users found',
      @required this.listType,
      Key key})
      : super(key: key);

  @override
  _UserPreviewWidgetState createState() => _UserPreviewWidgetState();
}

class _UserPreviewWidgetState extends State<UserPreviewWidget> {
  UserPreviewBloc _userPreviewBloc;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _userPreviewBloc = UserPreviewBloc(endpointBase: widget.listType);
    _userPreviewBloc.addEvent(UserPreviewEvent(
        refresh: false,
        sort: widget.sort,
        name: widget.name,
        query: widget.query));
    _scrollController = ScrollController()..addListener(_onScrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _userPreviewBloc.dispose();
  }

  void _onScrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!_userPreviewBloc.hitMax) {
        _userPreviewBloc.addEvent(UserPreviewEvent(
            refresh: false,
            sort: widget.sort,
            name: widget.name,
            query: widget.query));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserPreview>>(
      stream: _userPreviewBloc.modelStateStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<UserPreview>> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          if (widget.listType == LIKED_USERS) {
            _userPreviewBloc.hitMax = true;
          }

          return RefreshIndicator(
            onRefresh: () {
              return Future.delayed(Duration(milliseconds: 0), () {
                print("Refreshing list");
                _userPreviewBloc.addEvent(UserPreviewEvent(
                    sort: widget.sort,
                    name: widget.name,
                    query: widget.query,
                    refresh: true));
              });
            },
            child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(
                    parent: const AlwaysScrollableScrollPhysics()),
                controller: _scrollController,
                itemCount: snapshot.data.length + 1,
                itemBuilder: (context, index) {
                  if (snapshot.data.length == 0) {
                    return Center(
                        child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              widget.emptyMessage,
                              style: Theme.of(context).textTheme.headline4,
                              textAlign: TextAlign.center,
                            )));
                  }

                  if (index >= snapshot.data.length &&
                      !_userPreviewBloc.hitMax) {
                    return Column(children: [
                      SizedBox(
                        height: 10,
                      ),
                      const SpinKitWave(size: 50, color: hanPurple),
                      SizedBox(
                        height: 5,
                      )
                    ]);
                  } else if (index >= snapshot.data.length) {
                    return SizedBox();
                  }

                  return UserPreviewCard(
                      userPreview: snapshot.data[index],
                      key: ObjectKey(snapshot.data[index]));
                }),
          );
        } else if (snapshot.hasError) {
          return Text("Error retrieving items...");
        }

        return const SpinKitRipple(size: 50, color: hanPurple);
      },
    );
  }
}
