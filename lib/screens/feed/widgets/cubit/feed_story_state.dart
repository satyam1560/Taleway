part of 'feed_story_cubit.dart';

enum FeedStoryStatus { initial, loading, succuss, paginating, error }

class FeedStoryState extends Equatable {
  final FeedStoryStatus status;
  final Failure? failure;

  final List<AppUser?> users;

  const FeedStoryState({
    required this.status,
    this.failure,
    required this.users,
  });

  factory FeedStoryState.initial() => const FeedStoryState(
        status: FeedStoryStatus.initial,
        users: [],
        failure: Failure(),
      );

  factory FeedStoryState.loaded({
    required List<AppUser?> users,
  }) =>
      FeedStoryState(
        status: FeedStoryStatus.succuss,
        users: users,
        failure: const Failure(),
      );

  @override
  List<Object?> get props => [
        status,
        users,
        failure,
      ];

  FeedStoryState copyWith({
    FeedStoryStatus? status,
    Failure? failure,
    List<AppUser?>? users,
    List<List<Story?>>? feedStories,
  }) {
    return FeedStoryState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      users: users ?? this.users,
    );
  }
}
