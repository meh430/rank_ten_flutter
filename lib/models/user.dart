class User {
  int userId;
  int dateCreated;
  String username;
  String password;
  String bio;
  String profilePic;
  int rankPoints;
  int numLists;
  int numComments;
  int numFollowing;
  int numFollowers;
  Set<int> following;
  Set<int> likedLists;
  Set<int> likedComments;
  String jwtToken;

  User(
      {this.userId,
      this.dateCreated,
      this.username,
      this.password,
      this.bio,
      this.profilePic,
      this.rankPoints,
      this.numLists,
      this.numComments,
      this.numFollowing,
      this.numFollowers,
      this.following,
      this.likedLists,
      this.likedComments,
      this.jwtToken});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    dateCreated = json['dateCreated'];
    username = json['username'];
    password = json['password'];
    bio = json['bio'] == null ? "" : json['bio'];
    profilePic = json['profilePic'] == null ? "" : json['profilePic'];
    rankPoints = json['rankPoints'];
    numLists = json['numLists'];
    numComments = json['numComments'];
    numFollowing = json['numFollowing'];
    numFollowers = json['numFollowers'];
    if (json['following'] != null) {
      following = new Set<int>();
      json['following'].forEach((v) {
        following.add(v);
      });
    }
    if (json['likedLists'] != null) {
      likedLists = new Set<int>();
      json['likedLists'].forEach((v) {
        likedLists.add(v);
      });
    }
    if (json['likedComments'] != null) {
      likedComments = new Set<int>();
      json['likedComments'].forEach((v) {
        likedComments.add(v);
      });
    }
    jwtToken = json['jwtToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['dateCreated'] = this.dateCreated;
    data['username'] = this.username;
    data['password'] = this.password;
    data['bio'] = this.bio;
    data['profilePic'] = this.profilePic;
    data['rankPoints'] = this.rankPoints;
    data['numLists'] = this.numLists;
    data['numComments'] = this.numComments;
    data['numFollowing'] = this.numFollowing;
    data['numFollowers'] = this.numFollowers;
    if (this.following != null) {
      data['following'] = this.following.map((v) => v).toList();
    }
    if (this.likedLists != null) {
      data['likedLists'] = this.likedLists.map((v) => v).toList();
    }
    if (this.likedComments != null) {
      data['likedComments'] = this.likedComments.map((v) => v).toList();
    }
    data['jwtToken'] = this.jwtToken;
    return data;
  }
}

class UserPreview {
  String username;
  String profilePic;
  String bio;
  int rankPoints, userId;

  UserPreview(
      {this.username, this.profilePic, this.bio, this.rankPoints, this.userId});

  UserPreview.fromJson(Map<String, dynamic> json) {
    rankPoints = json['rankPoints'];
    username = json['username'];
    userId = json['userId'];
    profilePic = json['profilePic'] == null ? "" : json['profilePic'];
    bio = json['bio'] == null ? "" : json['bio'];
  }
}
