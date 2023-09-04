part of 'feed_collection_bloc.dart';

abstract class FeedCollectionEvent extends Equatable {
  const FeedCollectionEvent();

  @override
  List<Object> get props => [];
}

class LoadStoryCollection extends FeedCollectionEvent {}

class DeleteCollection extends FeedCollectionEvent {}
