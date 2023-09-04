import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/models/app_user.dart';
import '/repositories/story/story_repository.dart';
import '/blocs/auth/auth_bloc.dart';
import '/models/failure.dart';
import '/models/story.dart';
import '/repositories/feed/feed_repository.dart';

part 'feed_story_state.dart';

class FeedStoryCubit extends Cubit<FeedStoryState> {
  final FeedRepository _feedRepo;
  final AuthBloc _authBloc;
  final String? _collectionName;
  FeedStoryCubit({
    required FeedRepository feedRepository,
    required AuthBloc authBloc,
    required String? collectionName,
    required StoryRepository storyRepository,
  })  : _feedRepo = feedRepository,
        _authBloc = authBloc,
        _collectionName = collectionName,
        super(FeedStoryState.initial());

  void loadFeedStories() async {
    try {
      emit(state.copyWith(status: FeedStoryStatus.loading));

      final users = await _feedRepo.collectionUsers(
          collectionName: _collectionName, userId: _authBloc.state.user?.uid);
      final allUsers = await Future.wait(users);

      emit(FeedStoryState.loaded(users: allUsers));
    } catch (error) {
      print('Error getting stories -- ${error.toString()}');
    }
  }

  void paginatePost() async {
    try {
      emit(state.copyWith(status: FeedStoryStatus.paginating));

      //  final lastUserId = state.users.isNotEmpty ? state.users.last?.uid : null;

      final users = await _feedRepo.collectionUsers(
        userId: _authBloc.state.user?.uid,
        collectionName: _collectionName,
        // lastDocId: lastUserId,
      );
      final allUsers = await Future.wait(users);

      print('All users --- ${allUsers.length}');

      emit(FeedStoryState.loaded(users: allUsers));
    } catch (error) {
      print('Error in paginating post -- ${error.toString()}');
    }
  }
}
