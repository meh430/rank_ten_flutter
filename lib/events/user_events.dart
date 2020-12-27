abstract class UserEvent {}

class UpdateBioEvent extends UserEvent {
  final String bio, token;

  UpdateBioEvent({this.bio, this.token});
}

class UpdateProfilePicEvent extends UserEvent {
  final String profilePic, token;

  UpdateProfilePicEvent({this.profilePic, this.token});
}

class GetUserEvent extends UserEvent {
  final int userId;
  final String token;

  GetUserEvent(this.userId, {this.token = ""});
}
