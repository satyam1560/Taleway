import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/blocs/auth/auth_bloc.dart';
import '/models/app_user.dart';
import '/models/failure.dart';
import '/repositories/feed/feed_repository.dart';

part 'feed_collection_event.dart';
part 'feed_collection_state.dart';

class FeedCollectionBloc
    extends Bloc<FeedCollectionEvent, FeedCollectionState> {
  final AuthBloc _authBloc;
  final FeedRepository _feedRepository;
  final String? _collectionName;

  FeedCollectionBloc({
    required AuthBloc authBloc,
    required FeedRepository feedRepository,
    required String? collectionName,
  })  : _authBloc = authBloc,
        _collectionName = collectionName,
        _feedRepository = feedRepository,
        super(FeedCollectionState.initial()) {
    on<FeedCollectionEvent>((event, emit) async {
      if (event is LoadStoryCollection) {
        emit(state.copyWith(status: FeedCollectionStatus.loading));
        final userData = await _feedRepository.collectionUsers(
            userId: _authBloc.state.user?.uid, collectionName: _collectionName);

        final users = await Future.wait(userData);

        emit(FeedCollectionState.loaded(users: users));
      } else if (event is DeleteCollection) {
        await _feedRepository.deleteUserFeedCollectin(
            userId: _authBloc.state.user?.uid, collectionName: collectionName);
      }
    });
  }
}
