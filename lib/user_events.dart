abstract class UserEvent {}

class UpdateBioEvent extends UserEvent {
  final String bio, token;

  UpdateBioEvent(this.bio, this.token);
}

class UpdateProfilePicEvent extends UserEvent {
  final String profPic, token;

  UpdateProfilePicEvent(this.profPic, this.token);
}

class FollowEvent extends UserEvent {
  final String name, token;

  FollowEvent(this.name, this.token);
}

class GetUserEvent extends UserEvent {
  final String name;

  GetUserEvent(this.name);
}

class CreateList extends UserEvent {}

class DeleteList extends UserEvent {}
