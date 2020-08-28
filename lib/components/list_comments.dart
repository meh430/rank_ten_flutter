import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/blocs/comment_bloc.dart';
import 'package:rank_ten/components/comment_card.dart';
import 'package:rank_ten/events/comments_event.dart';
import 'package:rank_ten/misc/app_theme.dart';
import 'package:rank_ten/misc/utils.dart';
import 'package:rank_ten/models/comment.dart';
import 'package:rank_ten/providers/dark_theme_provider.dart';
import 'package:rank_ten/providers/main_user_provider.dart';
import 'package:rank_ten/routes/main_screen.dart';

class ListComments extends StatefulWidget {
  final String listId;

  ListComments({Key key, @required this.listId}) : super(key: key);

  @override
  _ListCommentsState createState() => _ListCommentsState();
}

class _ListCommentsState extends State<ListComments> {
  CommentBloc _commentBloc;
  ScrollController _scrollController;
  TextEditingController _commentController;
  int _sortOption = 0;

  @override
  void initState() {
    super.initState();
    _commentBloc = CommentBloc();
    _commentController = TextEditingController();
    _commentBloc.modelEventSink
        .add(GetListCommentsEvent(listId: widget.listId));
    _scrollController = ScrollController()..addListener(_onScrollListener);
  }

  void _onScrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!_commentBloc.hitMax) {
        _commentBloc.modelEventSink.add(
            GetListCommentsEvent(listId: widget.listId, sort: _sortOption));
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _commentBloc.dispose();
    _scrollController.dispose();
  }

  void _sortCallback(String option) {
    print(option);
    if (option.contains("like")) {
      _sortOption = LIKES_DESC;
    } else if (option.contains("newest")) {
      _sortOption = DATE_DESC;
    } else if (option.contains("oldest")) {
      _sortOption = DATE_ASC;
    }

    _commentBloc.modelEventSink.add(GetListCommentsEvent(
        listId: widget.listId, sort: _sortOption, refresh: true));
  }

  @override
  Widget build(BuildContext context) {
    var isDark = Provider.of<DarkThemeProvider>(context, listen: false).isDark;
    var userProvider = Provider.of<MainUserProvider>(context, listen: false);
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding:
                      EdgeInsets.only(bottom: 10, top: 14, left: 18, right: 16),
                  child: Text("Comments",
                      style: Theme.of(context).textTheme.headline4)),
              getSortAction(
                  context: context, isDark: isDark, sortCallback: _sortCallback)
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 4, bottom: 4),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: TextField(
                  controller: _commentController,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontSize: 18),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      _commentBloc.modelEventSink.add(AddCommentEvent(
                          token: userProvider.jwtToken,
                          listId: widget.listId,
                          comment: value));
                      _commentController.clear();
                    }
                  },
                  decoration: InputDecoration(
                      hintStyle: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontSize: 18),
                      hintText: "Send a comment"),
                )),
                IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      var value = _commentController.text;
                      if (value.isNotEmpty) {
                        _commentBloc.modelEventSink.add(AddCommentEvent(
                            token: userProvider.jwtToken,
                            listId: widget.listId,
                            comment: value));
                        _commentController.clear();
                      }
                    })
              ],
            ),
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
                              listId: widget.listId,
                              refresh: true,
                              sort: _sortOption));
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
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .headline4,
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

                            var isMain = snapshot.data[index].userName ==
                                userProvider.mainUser.userName;

                            return isMain
                                ? Dismissible(
                              background: Container(color: Colors.red),
                              key: ObjectKey(snapshot.data[index]),
                              onDismissed: (direction) {
                                _commentBloc.modelEventSink.add(
                                    DeleteCommentEvent(
                                        token: userProvider.jwtToken,
                                        commentId:
                                        snapshot.data[index].id));
                              },
                              child: CommentCard(
                                  editCallback: (value) {
                                    if (value.isNotEmpty) {
                                      _commentBloc.modelEventSink.add(
                                          UpdateCommentEvent(
                                              commentId:
                                              snapshot.data[index].id,
                                              comment: value,
                                              token:
                                              userProvider.jwtToken));
                                    }
                                  },
                                  comment: snapshot.data[index],
                                  isMain: true),
                            )
                                : CommentCard(
                                comment: snapshot.data[index],
                                isMain: false);
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
      ),
    );
  }
}
