import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rank_ten/blocs/comment_bloc.dart';
import 'package:rank_ten/components/comment_card.dart';
import 'package:rank_ten/events/comments_event.dart';
import 'package:rank_ten/misc/app_theme.dart';
import 'package:rank_ten/models/comment.dart';

class ListComments extends StatefulWidget {
  final String listId;

  ListComments({Key key, @required this.listId}) : super(key: key);

  @override
  _ListCommentsState createState() => _ListCommentsState();
}

class _ListCommentsState extends State<ListComments> {
  CommentBloc _commentBloc;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _commentBloc = CommentBloc();
    _commentBloc.modelEventSink
        .add(GetListCommentsEvent(listId: widget.listId));
    _scrollController = ScrollController()..addListener(_onScrollListener);
  }

  void _onScrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!_commentBloc.hitMax) {
        _commentBloc.modelEventSink
            .add(GetListCommentsEvent(listId: widget.listId));
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _commentBloc.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text("69 Comments"),
            IconButton(
              icon: Icon(Icons.sort),
              onPressed: () => print("sort"),
            )
          ],
        ),
        Expanded(
          child: StreamBuilder<List<Comment>>(
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return RefreshIndicator(
                    onRefresh: () {
                      return Future.delayed(Duration(milliseconds: 0), () {
                        print("Refreshing list");
                        _commentBloc.modelEventSink.add(GetListCommentsEvent(
                            listId: widget.listId, refresh: true));
                      });
                    },
                    child: ListView.builder(
                        shrinkWrap: false,
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
                                      "No comments",
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                      textAlign: TextAlign.center,
                                    )));
                          }

                          if (index >= snapshot.data.length &&
                              !_commentBloc.hitMax) {
                            return Column(children: [
                              SizedBox(
                                height: 10,
                              ),
                              SpinKitWave(size: 50, color: hanPurple),
                              SizedBox(
                                height: 5,
                              )
                            ]);
                          } else if (index >= snapshot.data.length) {
                            return SizedBox();
                          }

                          return CommentCard(
                              comment: snapshot.data[index],
                              key: ObjectKey(snapshot.data[index]));
                        }),
                  );
                } else if (snapshot.hasError) {
                  return Text("Error retrieving items...");
                }

                return SpinKitRipple(size: 50, color: hanPurple);
              },
              stream: _commentBloc.modelStateStream),
        )
      ],
    );
  }
}
