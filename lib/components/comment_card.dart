import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/components/ranked_list_card_widget.dart';
import 'package:rank_ten/misc/app_theme.dart';
import 'package:rank_ten/models/comment.dart';
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
    var userProvider = Provider.of<MainUserProvider>(context);
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeader(
              profPicUrl: widget.comment.profPic,
              userName: widget.comment.userName,
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
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline5)),
          ),
          CardFooter(
              numLikes: widget.comment.numLikes,
              id: widget.comment.id,
              isLiked:
              widget.comment.likedUsers.contains(userProvider.mainUser.id),
              isList: false)
        ],
      ),
    );
  }
}

void editCommentDialog(
    {BuildContext context, String comment, dynamic editCallback}) {
  var commentController = TextEditingController(text: comment);
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
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline5,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    controller: commentController,
                    textInputAction: TextInputAction.done,
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: FlatButton(
                    color: hanPurple,
                    onPressed: () {
                      editCallback(commentController.text);
                      Navigator.pop(context);
                    },
                    child: Text("Done",
                        style: Theme
                            .of(context)
                            .textTheme
                            .headline6),
                  ),
                )
              ],
            ),
          ),
        );
      });
}
