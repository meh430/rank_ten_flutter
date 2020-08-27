abstract class UserEvent {}

class UpdateBioEvent extends UserEvent {
  final String bio, token;

  UpdateBioEvent({this.bio, this.token});
}

class UpdateProfilePicEvent extends UserEvent {
  final String profPic, token;

  UpdateProfilePicEvent({this.profPic, this.token});
}

class FollowEvent extends UserEvent {
  final String name, token;

  FollowEvent({this.name, this.token});
}

class LikeListEvent extends UserEvent {
  final String id, token;

  LikeListEvent({this.id, this.token});
}

class LikeCommentEvent extends UserEvent {
  final String id, token;

  LikeCommentEvent({this.id, this.token});
}

class GetUserEvent extends UserEvent {
  final String name;
  final String token;

  GetUserEvent(this.name, {this.token = ""});
}