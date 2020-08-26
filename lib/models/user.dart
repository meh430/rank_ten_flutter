class User {
  String id;
  int dateCreated;
  String userName;
  String bio;
  String profPic;
  int numFollowers;
  int numFollowing;
  int rankPoints;
  int numComments;
  int numLiked;
  int listNum;
  String jwtToken;
  Set<String> followers;
  Set<String> following;
  Set<String> likedLists;

  User(
      {this.id,
      this.dateCreated,
      this.userName,
      this.bio,
      this.profPic,
      this.numFollowers,
      this.numFollowing,
      this.rankPoints,
      this.numComments,
      this.numLiked,
      this.listNum,
      this.jwtToken,
      this.likedLists,
      this.followers,
      this.following});

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'] != null ? json['_id'][r'$oid'] : null;
    dateCreated =
    json['date_created'] != null ? json['date_created'][r'$date'] : null;
    userName = json['user_name'];
    bio = json['bio'];
    profPic = json['prof_pic'];
    rankPoints = json['rank_points'];
    numComments = json['num_comments'];
    numFollowers = json['num_followers'];
    numFollowing = json['num_following'];
    numLiked = json['num_liked'];

    if (json['following'] != null) {
      following = Set<String>();
      json['following'].forEach((v) => following.add(v[r'$oid']));
    }

    if (json['followers'] != null) {
      followers = Set<String>();
      json['followers'].forEach((v) => followers.add(v[r'$oid']));
    }

    listNum = json['list_num'];
    jwtToken = json['jwt_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    //if (this.dateCreated != null) {
    //data['date_created'][r'$date'] = dateCreated;
    //}

    //data['user_name'] = this.userName;
    data['bio'] = this.bio;
    data['prof_pic'] = this.profPic;
    //data['rank_points'] = this.rankPoints;
    //data['num_comments'] = this.numComments;
    //data['list_num'] = this.listNum;

    return data;
  }

  @override
  String toString() {
    return "Name: $userName";
  }
}

class UserPreview {
  String userName;
  String profPic;
  String bio;
  int rankPoints;

  UserPreview({this.userName, this.profPic, this.bio, this.rankPoints});

  UserPreview.fromJson(Map<String, dynamic> json) {
    print(json);
    rankPoints = json['rank_points'];
    userName = json['user_name'];
    profPic = json['prof_pic'];
    bio = json['bio'];
  }
}
