part of 'profile_story_cubit.dart';

enum ProfileStoryStatus { initial, loading, succuss, error }

class ProfileStoryState extends Equatable {
  final List<Story?> stories;
  final ProfileStoryStatus status;
  final Failure failure;

  const ProfileStoryState({
    required this.stories,
    required this.status,
    required this.failure,
  });

  @override
  List<Object> get props => [stories, status, failure];

  ProfileStoryState copyWith({
    List<Story?>? stories,
    ProfileStoryStatus? status,
    Failure? failure,
  }) {
    return ProfileStoryState(
      stories: stories ?? this.stories,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  factory ProfileStoryState.inital() => const ProfileStoryState(
      stories: [], status: ProfileStoryStatus.initial, failure: Failure());

  factory ProfileStoryState.loaded({required List<Story?> stories}) =>
      ProfileStoryState(
        stories: stories,
        status: ProfileStoryStatus.succuss,
        failure: const Failure(),
      );

  @override
  String toString() =>
      'ProfileStoryState(stories: $stories, status: $status, failure: $failure)';
}
