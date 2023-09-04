part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadUserProfile extends ProfileEvent {
  // final AppUser? appUser;
  // final List<String?> collectionName;

  //const LoadUserProfile({required this.appUser, required this.collectionName});
}

class LoadProfileStoriesSection extends ProfileEvent {
  final String collectionName;

  const LoadProfileStoriesSection({required this.collectionName});

  @override
  List<Object> get props => [collectionName];
}

class NewCollectionNameChanged extends ProfileEvent {
  final String collName;

  const NewCollectionNameChanged({required this.collName});

  @override
  List<Object> get props => [collName];
}

class AddNewProfileCollection extends ProfileEvent {}
