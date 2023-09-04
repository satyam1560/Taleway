part of 'others_profile_bloc.dart';

abstract class OthersProfileEvent extends Equatable {
  const OthersProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadOthersProfile extends OthersProfileEvent {}

class FollowUser extends OthersProfileEvent {}

class UnFollowUser extends OthersProfileEvent {}

class AddToUserFeedCollection extends OthersProfileEvent {}

class BlockUser extends OthersProfileEvent {}

class UnBlockUser extends OthersProfileEvent {}
