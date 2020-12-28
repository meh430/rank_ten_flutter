class Comment {
  int commentId;
  int userId;
  int listId;
  int dateCreated;
  String comment;
  String username;
  String profilePic;
  int numLikes;

  Comment(
      {this.commentId,
      this.userId,
      this.listId,
      this.dateCreated,
      this.comment,
      this.username,
      this.profilePic,
      this.numLikes});

  Comment.fromJson(Map<String, dynamic> json) {
    commentId = json['commentId'];
    userId = json['userId'];
    listId = json['listId'];
    dateCreated = json['dateCreated'];
    comment = json['comment'] == null ? "" : json['comment'];
    username = json['username'];
    profilePic = json['profilePic'] == null ? "" : json['profilePic'];
    numLikes = json['numLikes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //data['commentId'] = this.commentId;
    //data['userId'] = this.userId;
    //data['listId'] = this.listId;
    //data['dateCreated'] = this.dateCreated;
    data['comment'] = this.comment;
    //data['username'] = this.username;
    //data['profilePic'] = this.profilePic;
    //data['numLikes'] = this.numLikes;
    return data;
  }
}