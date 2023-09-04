import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/repositories/story/story_repository.dart';
import '/models/failure.dart';
import '/models/story.dart';

part 'user_stories_event.dart';
part 'user_stories_state.dart';

class UserStoriesBloc extends Bloc<UserStoriesEvent, UserStoriesState> {
  final StoryRepository _storyRepository;
  final String? _userId;
  UserStoriesBloc({
    required StoryRepository storyRepository,
    required String? userId,
  })  : _userId = userId,
        _storyRepository = storyRepository,
        super(UserStoriesState.initial()) {
    on<UserStoriesEvent>((event, emit) async {
      if (event is LoadUserStories) {
        final futureStories =
            await _storyRepository.getUserStories(userId: _userId);

        final stories = await Future.wait(futureStories);

        emit(UserStoriesState.loaded(stories: stories));
      }
    });
  }
}
