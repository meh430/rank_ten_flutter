abstract class UserEvent {
  final String x = "!23";
}

class UpdateBioEvent extends UserEvent {
  final String bio;

  UpdateBioEvent(this.bio);
}

class UpdateProfilePicEvent extends UserEvent {
  final String profPic;

  UpdateProfilePicEvent(this.profPic);
}

class FollowEvent extends UserEvent {
  final String name;

  FollowEvent(this.name);
}

class GetUserEvent extends UserEvent {
  final String name;

  GetUserEvent(this.name);
}

class CreateList extends UserEvent {}

class DeleteList extends UserEvent {}
