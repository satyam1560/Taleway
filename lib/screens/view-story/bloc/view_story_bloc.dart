import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:palette_generator/palette_generator.dart';
import '/models/app_user.dart';
import '/models/failure.dart';
import '/models/story.dart';
import '/repositories/story/story_repository.dart';
part 'view_story_event.dart';
part 'view_story_state.dart';

class ViewStoryBloc extends Bloc<ViewStoryEvent, ViewStoryState> {
  final StoryRepository _storyRepository;
  final String? _authorId;
  ViewStoryBloc({
    required StoryRepository storyRepository,
    required String? authorId,
  })  : _storyRepository = storyRepository,
        _authorId = authorId,
        super(ViewStoryState.initial()) {
    on<ViewStoryEvent>((event, emit) async {
      if (event is LoadStories) {
        emit(state.copyWith(status: ViewStoryStatus.loading));
        final futureStories =
            await _storyRepository.getUserTodayStories(userId: _authorId);

        final stories = await Future.wait(futureStories);

        List<PaletteColor> colors = [];

        // for (var story in stories) {
        //   if (story?.storyUrl != null) {
        //     final pallet = await PaletteGenerator.fromImageProvider(
        //         NetworkImage(story!.storyUrl!),
        //         timeout: const Duration(seconds: 2)
        //         // size: const Size(200, 100),
        //         );

        //     colors.add(pallet.vibrantColor ?? PaletteColor(Colors.black, 2));
        //   }
        // }

        print('Stories ---- $stories');

        emit(ViewStoryState.loaded(stories: stories, colors: colors));
      } else if (event is PageIndexChanged) {
        emit(state.copyWith(currentIndex: event.index));
      } else if (event is LoadPalletColors) {}
      // else if (event is LoadTaggedUsers) {
      //   final users = await _storyRepository.taggedUsers(
      //       storyId: event.storyId, tagUsers: event.tagUsers);
      //   emit(state.copyWith(taggedUsers: users));
      // }
    });
  }
}
