abstract class UserEvent {}

class UpdateBioEvent extends UserEvent {}

class UpdateProfilePicEvent extends UserEvent {}

class FollowEvent extends UserEvent {}

class CreateList extends UserEvent {}

class DeleteList extends UserEvent {}
