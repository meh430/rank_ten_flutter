class RankedListCard {
  String id;
  String userName;
  String profPic;
  String title;
  int dateCreated;
  int numLikes;
  int numItems;
  int numComments;
  CommentPreview commentPreview;
  List<RankItemPreview> rankList;
  String picture;

  RankedListCard(
      {this.id,
      this.userName,
      this.profPic,
      this.title,
      this.dateCreated,
      this.numLikes,
      this.numItems,
      this.numComments,
      this.commentPreview,
      this.rankList,
      this.picture});

  RankedListCard.fromJson(Map<String, dynamic> json) {
    print(json);
    id = json['_id'];
    userName = json['user_name'];
    profPic = json['prof_pic'];
    title = json['title'];
    dateCreated = json['date_created'][r'$date'];
    numLikes = json['num_likes'];
    numItems = json['num_rank_items'];
    numComments = json['num_comments'];
    commentPreview = json['comment_preview'] != null
        ? CommentPreview.fromJson(json['comment_preview'])
        : null;
    if (json['rank_list'] != null) {
      rankList = List<RankItemPreview>();
      json['rank_list'].forEach((v) {
        rankList.add(RankItemPreview.fromJson(v));
      });
    }
    picture = json['picture'];
  }
}

class CommentPreview {
  String comment;
  String userName;
  String profPic;
  int dateCreated;

  CommentPreview({this.comment, this.userName, this.dateCreated, this.profPic});

  CommentPreview.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    userName = json['user_name'];
    dateCreated = json['date_created'];
    profPic = json['prof_pic'];
  }
}

class RankItemPreview {
  String itemName;
  int rank;

  RankItemPreview({this.itemName, this.rank});

  RankItemPreview.fromJson(Map<String, dynamic> json) {
    itemName = json['item_name'];
    rank = json['rank'];
  }
}
