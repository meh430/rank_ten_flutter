import 'package:rank_ten/models/rank_item.dart';

class RankedList {
  String id;
  int dateCreated;
  String userName;
  String title;
  List<RankItem> rankList;
  int numLikes;
  int numComments;
  bool private;

  RankedList(
      {this.id,
      this.dateCreated,
      this.userName,
      this.title,
      this.rankList,
      this.numLikes,
      this.numComments,
      this.private});

  RankedList.fromJson(Map<String, dynamic> json) {
    id = json['_id'][r'$oid'];
    dateCreated = ((json['date_created'][r'$date'] as int) / 1000).floor();
    userName = json['user_name'];
    title = json['title'];
    if (json['rank_list'] != null) {
      rankList = List<RankItem>();
      json['rank_list'].forEach((v) {
        rankList.add(RankItem.fromJson(v));
      });
    }
    numLikes = json['num_likes'];
    numComments = json['num_comments'];
    private = json['private'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    //data['user_name'] = this.userName;
    data['title'] = this.title;
    if (this.rankList != null) {
      data['rank_list'] = this.rankList.map((v) => v.toJson()).toList();
    }
    data['private'] = this.private;
    //data['num_likes'] = this.numLikes;
    //data['num_comments'] = this.numComments;
    return data;
  }
}
