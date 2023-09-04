part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}

class LoadUserFeed extends FeedEvent {
  final AppUser? user;
  final List<String?> collectionNames;

  const LoadUserFeed({
    required this.user,
    required this.collectionNames,
  });
}

class AddNewFeedCollection extends FeedEvent {}

class Loading extends FeedEvent {}

class RefreshFeed extends FeedEvent {}

class NewCollectionNameChanged extends FeedEvent {
  final String collName;

  const NewCollectionNameChanged({required this.collName});

  @override
  List<Object> get props => [collName];
}
