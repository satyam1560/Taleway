import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '/blocs/auth/auth_bloc.dart';
import '/config/paths.dart';
import '/models/app_user.dart';
import '/models/failure.dart';
import '/repositories/feed/feed_repository.dart';
import '/repositories/user/user_repository.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final AuthBloc _authBloc;
  final FeedRepository _feedRepository;

  final UserRepository _userRepository;

  late StreamSubscription<AppUser?> _userSubscription;

  FeedBloc({
    required FeedRepository feedRepository,
    required AuthBloc authBloc,
    required UserRepository userRepository,
  })  : _authBloc = authBloc,
        _feedRepository = feedRepository,
        _userRepository = userRepository,
        super(FeedState.initial()) {
    _userSubscription = _userRepository
        .streamUserProfile(userId: _authBloc.state.user?.uid)
        .listen((userSnaps) async {
      add(Loading());
      final user = userSnaps;
      final stories = await _userRepository.getUserStoryCollection(
        userID: _authBloc.state.user?.uid,
        collectionName: Paths.feedList,
      );
      return add(LoadUserFeed(user: user, collectionNames: stories));
    });
    on<FeedEvent>((event, emit) async {
      if (event is Loading) {
        emit(state.copyWith(status: FeedStatus.loading));
      } else if (event is LoadUserFeed) {
        emit(FeedState.loaded(
            appUser: event.user, cNames: event.collectionNames));

        // print('feed bloc runs ----');
        // emit(state.copyWith(status: FeedStatus.loading));
        // final user = await _userRepository.getUserProfile(
        //     userId: _authBloc.state.user?.uid);

        // print('Feed bloc ap user $user');
        // final stories = await _userRepository.getUserStoryCollection(
        //   userID: _authBloc.state.user?.uid,
        //   collectionName: Paths.feedList,
        // );

        // print('Feed stores ------ $stories');

        // emit(FeedState.loaded(appUser: user, cNames: stories));
      } else if (event is AddNewFeedCollection) {
        if (state.newCollectionName != null && state.newCollectionName != '') {
          emit(state.copyWith(status: FeedStatus.loading));
          await _feedRepository.createNewFeedCollection(
              userId: _authBloc.state.user?.uid,
              collectionName: state.newCollectionName);

          final stories = await _userRepository.getUserStoryCollection(
            userID: _authBloc.state.user?.uid,
            collectionName: Paths.feedList,
          );

          add(LoadUserFeed(user: state.appUser, collectionNames: stories));
          //  add(LoadUserFeed(user: state.appUser, collectionNames: s));
        } else {
          emit(state.copyWith(
              status: FeedStatus.error,
              failure: const Failure(message: 'Error adding new collection')));
        }
      } else if (event is NewCollectionNameChanged) {
        emit(state.copyWith(newCollectionName: event.collName));
      } else if (event is RefreshFeed) {
        print('feed bloc runs ----');
        emit(state.copyWith(status: FeedStatus.loading));
        final user = await _userRepository.getUserProfile(
            userId: _authBloc.state.user?.uid);

        print('Feed bloc ap user $user');
        final stories = await _userRepository.getUserStoryCollection(
          userID: _authBloc.state.user?.uid,
          collectionName: Paths.feedList,
        );

        print('Feed stores ------ $stories');

        emit(FeedState.loaded(appUser: user, cNames: stories));

        // add(LoadUserFeed(user: user, collectionNames: collectionNames))
      }
    });
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
