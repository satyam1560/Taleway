import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/repositories/story/story_repository.dart';

import '/blocs/auth/auth_bloc.dart';
import '/config/paths.dart';
import '/models/app_user.dart';
import '/models/failure.dart';
import '/models/story.dart';
import '/repositories/user/user_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthBloc _authBloc;
  final UserRepository _userRepository;
  final StoryRepository _storyRepository;

  ProfileBloc({
    required AuthBloc authBloc,
    required UserRepository userRepository,
    required StoryRepository storyRepository,
  })  : _authBloc = authBloc,
        _userRepository = userRepository,
        _storyRepository = storyRepository,
        super(ProfileState.initial()) {
    on<ProfileEvent>((event, emit) async {
      if (event is LoadUserProfile) {
        emit(state.copyWith(status: ProfileStatus.loading));
        final user = await _userRepository.getUserProfile(
            userId: _authBloc.state.user?.uid);
        final stories = await _userRepository.getUserStoryCollection(
          userID: _authBloc.state.user?.uid,
          collectionName: Paths.storiesList,
        );

        final futureStories = await _storyRepository.getUserTodayStories(
          userId: _authBloc.state.user?.uid,
          // collection: Paths.userStories,
        );
        List<Story?> todayStories = [];

        for (var story in futureStories) {
          todayStories.add(await story);
        }

        emit(ProfileState.loaded(
            appUser: user, cNames: stories, todayStories: todayStories));
      } else if (event is LoadProfileStoriesSection) {
      } else if (event is AddNewProfileCollection) {
        if (state.newCollName != null && state.newCollName != '') {
          emit(state.copyWith(status: ProfileStatus.loading));
          await _userRepository.createNewProfileCollection(
              userId: _authBloc.state.user?.uid,
              collectionName: state.newCollName);

          add(LoadUserProfile());
        }
      } else if (event is NewCollectionNameChanged) {
        emit(state.copyWith(newCollName: event.collName));
      }
    });
  }
}
