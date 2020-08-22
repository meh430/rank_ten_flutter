class RankedListCard {
  String sId;
  String userName;
  String profPic;
  String title;
  int dateCreated;
  int numLikes;
  int numComments;
  CommentPreview commentPreview;
  List<RankItemPreview> rankList;
  String picture;

  RankedListCard(
      {this.sId,
      this.userName,
      this.profPic,
      this.title,
      this.dateCreated,
      this.numLikes,
      this.numComments,
      this.commentPreview,
      this.rankList,
      this.picture});

  RankedListCard.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userName = json['user_name'];
    profPic = json['prof_pic'];
    title = json['title'];
    dateCreated = json['date_created'][r'$date_created'];
    numLikes = json['num_likes'];
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

/*Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_name'] = this.userName;
    data['prof_pic'] = this.profPic;
    data['title'] = this.title;

    if (this.dateCreated != null) {
      data['date_created'] = this.dateCreated.toJson();
    }
    data['num_likes'] = this.numLikes;
    data['num_comments'] = this.numComments;
    if (this.commentPreview != null) {
      data['comment_preview'] = this.commentPreview.toJson();
    }
    if (this.rankList != null) {
      data['rank_list'] = this.rankList.map((v) => v.toJson()).toList();
    }
    data['picture'] = this.picture;
    return data;
  }*/
}

class CommentPreview {
  String comment;
  String userName;

  CommentPreview({this.comment, this.userName});

  CommentPreview.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['comment'] = this.comment;
    data['user_name'] = this.userName;
    return data;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['item_name'] = this.itemName;
    data['rank'] = this.rank;
    return data;
  }
}
