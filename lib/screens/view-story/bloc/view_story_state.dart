part of 'view_story_bloc.dart';

enum ViewStoryStatus { initial, loading, succuss, error }

class ViewStoryState extends Equatable {
  final List<Story?> stories;
  final Failure failure;
  final ViewStoryStatus status;
  final int currentIndex;
  final List<PaletteColor?> palletColors;
  final List<AppUser?> taggedUsers;

  const ViewStoryState({
    required this.stories,
    required this.failure,
    required this.status,
    required this.currentIndex,
    required this.palletColors,
    required this.taggedUsers,
  });

  ViewStoryState copyWith({
    List<Story?>? stories,
    Failure? failure,
    ViewStoryStatus? status,
    int? currentIndex,
    List<PaletteColor?>? palletColors,
    List<AppUser?>? taggedUsers,
  }) {
    return ViewStoryState(
      stories: stories ?? this.stories,
      failure: failure ?? this.failure,
      status: status ?? this.status,
      palletColors: palletColors ?? this.palletColors,
      currentIndex: currentIndex ?? this.currentIndex,
      taggedUsers: taggedUsers ?? this.taggedUsers,
    );
  }

  factory ViewStoryState.initial() => const ViewStoryState(
        stories: [],
        failure: Failure(),
        status: ViewStoryStatus.initial,
        currentIndex: 0,
        palletColors: [],
        taggedUsers: [],
      );

  factory ViewStoryState.loaded({
    required List<Story?> stories,
    required List<PaletteColor> colors,
  }) =>
      ViewStoryState(
        stories: stories,
        failure: const Failure(),
        status: ViewStoryStatus.succuss,
        currentIndex: 0,
        palletColors: colors,
        taggedUsers: const [],
      );

  @override
  List<Object> get props =>
      [stories, failure, status, palletColors, currentIndex];
}
