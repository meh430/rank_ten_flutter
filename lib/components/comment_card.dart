import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank_ten/components/ranked_list_card_widget.dart';
import 'package:rank_ten/models/comment.dart';
import 'package:rank_ten/providers/main_user_provider.dart';

class CommentCard extends StatefulWidget {
  final Comment comment;
  final bool isMain;

  CommentCard({Key key, this.comment, this.isMain}) : super(key: key);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<MainUserProvider>(context);
    return Card(
      child: Column(
        children: [
          CardHeader(
              profPicUrl: widget.comment.profPic,
              userName: widget.comment.userName,
              dateCreated: widget.comment.dateCreated),
          Text(widget.comment.comment),
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
