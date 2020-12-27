import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/components/choose_pic.dart';
import 'package:rank_ten/components/login.dart';
import 'package:rank_ten/components/ranked_list_card_widget.dart';
import 'package:rank_ten/models/comment.dart';
import 'package:rank_ten/providers/dark_theme_provider.dart';
import 'package:rank_ten/providers/main_user_provider.dart';

class CommentCard extends StatefulWidget {
  final Comment comment;
  final bool isMain;
  final editCallback;

  CommentCard(
      {Key key,
      @required this.comment,
      @required this.isMain,
      this.editCallback})
      : super(key: key);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<MainUserProvider>(context, listen: false);
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeader(
              profPicUrl: widget.comment.profilePic,
              userId: widget.comment.userId,
              userName: widget.comment.username,
              dateCreated: widget.comment.dateCreated),
          GestureDetector(
            onTap: () {
              if (widget.isMain) {
                editCommentDialog(
                    context: context,
                    comment: widget.comment.comment,
                    editCallback: widget.editCallback);
              }
            },
            child: Padding(
                padding: const EdgeInsets.only(left: 40, bottom: 6, top: 6),
                child: Text(widget.comment.comment,
                    style: Theme.of(context).textTheme.headline5)),
          ),
          CardFooter(
              numLikes: widget.comment.numLikes,
              id: widget.comment.commentId,
              isLiked: userProvider.mainUser.likedComments
                  .contains(widget.comment.commentId),
              isList: false)
        ],
      ),
    );
  }
}

void editCommentDialog(
    {BuildContext context, String comment, dynamic editCallback}) {
  var commentController = TextEditingController(text: comment);
  var isDark = Provider.of<DarkThemeProvider>(context, listen: false).isDark;
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    "Edit comment",
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                      textInputAction: TextInputAction.done,
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontSize: 16),
                      controller: commentController,
                      maxLines: null,
                      decoration: InputDecoration(
                          labelText: 'Comment',
                          contentPadding: const EdgeInsets.all(20.0),
                          labelStyle: Theme
                              .of(context)
                              .textTheme
                              .headline6
                              .copyWith(fontSize: 16),
                          border: getInputStyle(isDark),
                          enabledBorder: getInputStyle(isDark),
                          focusedBorder: getInputStyle(isDark))),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: buildDialogButton(
                        context: context,
                        label: "Done",
                        onPressed: () {
                          editCallback(commentController.text);
                          Navigator.pop(context);
                        }))
              ],
            ),
          ),
        );
      });
}
