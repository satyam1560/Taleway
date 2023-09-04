import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/models/failure.dart';
import '/models/story.dart';
import '/repositories/story/story_repository.dart';
part 'profile_story_state.dart';

class ProfileStoryCubit extends Cubit<ProfileStoryState> {
  final String? _collectionName;

  final StoryRepository _storyRepository;
  final String? _userId;
  //final AuthBloc _authBloc;

  ProfileStoryCubit({
    required String? collectionName,
    required StoryRepository storyRepository,
    required String? userId,
  })  : _storyRepository = storyRepository,
        _userId = userId,
        _collectionName = collectionName,
        super(ProfileStoryState.inital()) {
    print('Other usr id ------- $_userId');
    if (_collectionName != null && _userId != null) {
      print('Collection Name -- $_collectionName');
      print('User id ------ $_userId');
      _storyRepository
          .streamUserStories(userId: _userId, collectionName: _collectionName!)
          .listen((futureStories) async {
        final stories = await Future.wait(futureStories);
        print('Stpries ------- $stories');
        emit(ProfileStoryState.loaded(stories: stories));
      });
    }
  }
}
