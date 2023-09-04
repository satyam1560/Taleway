part of 'view_story_bloc.dart';

abstract class ViewStoryEvent extends Equatable {
  const ViewStoryEvent();

  @override
  List<Object> get props => [];
}

class LoadStories extends ViewStoryEvent {}

class PageIndexChanged extends ViewStoryEvent {
  final int index;

  const PageIndexChanged({required this.index});

  @override
  List<Object> get props => [index];
}

class LoadPalletColors extends ViewStoryEvent {}

// class LoadTaggedUsers extends ViewStoryEvent {
//   final List<TagUser?> tagUsers;
//   final String? storyId;

//   const LoadTaggedUsers({
//     required this.tagUsers,
//     required this.storyId,
//   });
// }
