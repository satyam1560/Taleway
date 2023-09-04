part of 'user_stories_bloc.dart';

enum UserStoriesStatus { initial, loading, succuss, error }

class UserStoriesState extends Equatable {
  final List<Story?> stories;
  final Failure failure;
  final UserStoriesStatus status;

  const UserStoriesState({
    required this.stories,
    required this.failure,
    required this.status,
  });

  factory UserStoriesState.initial() => const UserStoriesState(
      stories: [], failure: Failure(), status: UserStoriesStatus.initial);

  factory UserStoriesState.loaded({required List<Story?> stories}) =>
      UserStoriesState(
          stories: stories,
          failure: const Failure(),
          status: UserStoriesStatus.succuss);

  UserStoriesState copyWith({
    List<Story?>? stories,
    Failure? failure,
    UserStoriesStatus? status,
  }) {
    return UserStoriesState(
      stories: stories ?? this.stories,
      failure: failure ?? this.failure,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [stories, failure, status];
}
