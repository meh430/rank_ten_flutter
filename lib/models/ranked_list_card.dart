class RankedListCard {
  int listId;
  int userId;
  int dateCreated;
  String title;
  bool private;
  String username;
  String profilePic;
  int numLikes;
  int numComments;
  List<RankItemPreview> rankItems;
  int numItems;
  String picture;
  CommentPreview commentPreview;

  RankedListCard(
      {this.listId,
      this.userId,
      this.dateCreated,
      this.title,
      this.private,
      this.username,
      this.profilePic,
      this.numLikes,
      this.numComments,
      this.rankItems,
      this.numItems,
      this.picture,
      this.commentPreview});

  RankedListCard.fromJson(Map<String, dynamic> json) {
    listId = json['listId'];
    userId = json['userId'];
    dateCreated = json['dateCreated'];
    title = json['title'];
    private = json['private'] == 0 ? false : true;
    username = json['username'];
    profilePic = json['profilePic'] == null ? "" : json['profilePic'];
    numLikes = json['numLikes'];
    numComments = json['numComments'];
    if (json['rankItems'] != null) {
      rankItems = new List<RankItemPreview>();
      json['rankItems'].forEach((v) {
        rankItems.add(new RankItemPreview.fromJson(v));
      });
    }
    numItems = json['numItems'];
    picture = json['picture'] == null ? "" : json['picture'];
    commentPreview =
        json.containsKey('commentPreview') && json['commentPreview'] != null
            ? new CommentPreview.fromJson(json['commentPreview'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listId'] = this.listId;
    data['userId'] = this.userId;
    data['dateCreated'] = this.dateCreated;
    data['title'] = this.title;
    data['private'] = this.private;
    data['username'] = this.username;
    data['profilePic'] = this.profilePic;
    data['numLikes'] = this.numLikes;
    data['numComments'] = this.numComments;
    if (this.rankItems != null) {
      data['rankItems'] = this.rankItems.map((v) => v.toJson()).toList();
    }
    data['numItems'] = this.numItems;
    data['picture'] = this.picture;
    if (this.commentPreview != null) {
      data['commentPreview'] = this.commentPreview.toJson();
    }
    return data;
  }
}

class RankItemPreview {
  String itemName;
  int ranking;

  RankItemPreview({this.itemName, this.ranking});

  RankItemPreview.fromJson(Map<String, dynamic> json) {
    itemName = json['itemName'];
    ranking = json['ranking'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemName'] = this.itemName;
    data['ranking'] = this.ranking;
    return data;
  }
}

class CommentPreview {
  String comment;
  String profilePic;
  String username;
  int userId;
  int dateCreated;

  CommentPreview(
      {this.comment,
      this.profilePic,
      this.username,
      this.userId,
      this.dateCreated});

  CommentPreview.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    profilePic = json['profilePic'] == null ? "" : json['profilePic'];
    username = json['username'];
    userId = json['userId'];
    dateCreated = json['dateCreated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment'] = this.comment;
    data['profilePic'] = this.profilePic;
    data['username'] = this.username;
    data['userId'] = this.userId;
    data['dateCreated'] = this.dateCreated;
    return data;
  }
}
