class Comment {
  String id;
  String belongsTo;
  String comment;
  int dateCreated;
  bool edited;
  Set<String> likedUsers;
  int numLikes;
  String profPic;
  String userName;

  Comment(
      {this.id,
      this.belongsTo,
      this.comment,
      this.dateCreated,
      this.edited,
      this.likedUsers,
      this.numLikes,
      this.profPic,
      this.userName});

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['_id'][r'$oid'];
    belongsTo = json['belongs_to'][r'$oid'];
    comment = json['comment'];
    dateCreated = ((json['date_created'][r'$date'] as int) / 1000).floor();
    edited = json['edited'];
    if (json['liked_users'] != null) {
      likedUsers = new Set<String>();
      json['liked_users'].forEach((v) {
        likedUsers.add(v[r'$oid']);
      });
    }
    numLikes = json['num_likes'];
    profPic = json['prof_pic'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment'] = this.comment;
    return data;
  }
}
