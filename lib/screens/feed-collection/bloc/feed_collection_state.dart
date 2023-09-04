part of 'feed_collection_bloc.dart';

enum FeedCollectionStatus { initial, loading, succuss, error }

class FeedCollectionState extends Equatable {
  final List<AppUser?> users;
  final FeedCollectionStatus status;
  final Failure failure;

  const FeedCollectionState({
    required this.users,
    required this.status,
    required this.failure,
  });

  factory FeedCollectionState.initial() => const FeedCollectionState(
      users: [], status: FeedCollectionStatus.initial, failure: Failure());

  factory FeedCollectionState.loaded({required List<AppUser?> users}) =>
      FeedCollectionState(
          users: users,
          status: FeedCollectionStatus.succuss,
          failure: const Failure());

  FeedCollectionState copyWith({
    List<AppUser?>? users,
    FeedCollectionStatus? status,
    Failure? failure,
  }) {
    return FeedCollectionState(
      users: users ?? this.users,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object> get props => [users, status, failure];
}
