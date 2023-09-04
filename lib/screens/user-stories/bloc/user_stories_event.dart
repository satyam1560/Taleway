part of 'user_stories_bloc.dart';

abstract class UserStoriesEvent extends Equatable {
  const UserStoriesEvent();

  @override
  List<Object> get props => [];
}

class LoadUserStories extends UserStoriesEvent {}
