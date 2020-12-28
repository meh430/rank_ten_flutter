import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/api/preferences_store.dart';
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
  final int listId;

  ListComments({Key key, @required this.listId}) : super(key: key);

  @override
  _ListCommentsState createState() => _ListCommentsState();
}

class _ListCommentsState extends State<ListComments> {
  CommentBloc _commentBloc;
  ScrollController _scrollController;
  TextEditingController _commentController;
  int _sortOption = PreferencesStore.currentSort;

  @override
  void initState() {
    super.initState();
    _commentBloc = CommentBloc();
    _commentController = TextEditingController();
    _commentBloc.addEvent(
        GetListCommentsEvent(listId: widget.listId, sort: _sortOption));
    _scrollController = ScrollController()..addListener(_onScrollListener);
  }

  void _onScrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!_commentBloc.hitMax) {
        _commentBloc.addEvent(
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

  void _sortCallback(int option) {
    _sortOption = option;
    PreferencesStore.saveSort(option);
    _commentBloc.resetPage();
    _commentBloc.addEvent(
        GetListCommentsEvent(listId: widget.listId, sort: _sortOption));
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
                      style: Theme.of(context).textTheme.headline5)),
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
                      _commentBloc.addEvent(AddCommentEvent(
                          token: userProvider.jwtToken,
                          listId: widget.listId,
                          comment: value));
                      _commentController.clear();
                    }
                  },
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: secondText)),
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
                        _commentBloc.addEvent(AddCommentEvent(
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
                          _commentBloc.addEvent(GetListCommentsEvent(
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                        textAlign: TextAlign.center,
                                      )));
                            }

                            if (index >= snapshot.data.length &&
                                !_commentBloc.hitMax) {
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

                            var isMain = snapshot.data[index].userId ==
                                userProvider.mainUser.userId;
                            return isMain
                                ? Dismissible(
                                    background: Container(color: Colors.red),
                                    key: ObjectKey(snapshot.data[index]),
                                    onDismissed: (direction) {
                                      _commentBloc.addEvent(DeleteCommentEvent(
                                          token: userProvider.jwtToken,
                                          commentId:
                                              snapshot.data[index].commentId));
                                    },
                                    child: CommentCard(
                                        editCallback: (value) {
                                          if (value.isNotEmpty) {
                                            _commentBloc.addEvent(
                                                UpdateCommentEvent(
                                                    commentId: snapshot
                                                        .data[index].commentId,
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
                    WidgetsBinding.instance.addPostFrameCallback(
                        (_) => Utils.showSB("Error getting comments", context));
                    return Utils.getErrorImage();
                  }

                  return const SpinKitRipple(size: 50, color: hanPurple);
                },
                stream: _commentBloc.modelStateStream),
          )
        ],
      ),
    );
  }
}
