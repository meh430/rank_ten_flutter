import 'package:rank_ten/models/rank_item.dart';

class RankedList {
  int listId;
  int userId;
  int dateCreated;
  String title;
  bool private;
  String username;
  String profilePic;
  int numLikes;
  int numComments;
  List<RankItem> rankItems;

  RankedList(
      {this.listId,
      this.userId,
      this.dateCreated,
      this.title,
      this.private,
      this.username,
      this.profilePic,
      this.numLikes,
      this.numComments,
      this.rankItems});

  RankedList.fromJson(Map<String, dynamic> json) {
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
      rankItems = new List<RankItem>();
      json['rankItems'].forEach((v) {
        rankItems.add(new RankItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //data['listId'] = this.listId;
    //data['userId'] = this.userId;
    //data['dateCreated'] = this.dateCreated;
    data['title'] = this.title;
    data['private'] = this.private;
    //data['username'] = this.username;
    //data['profilePic'] = this.profilePic;
    //data['numLikes'] = this.numLikes;
    //data['numComments'] = this.numComments;
    if (this.rankItems != null) {
      data['rankItems'] = this.rankItems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
