import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:viewstories/blocs/auth/auth_bloc.dart';
import 'package:viewstories/config/paths.dart';
import 'package:viewstories/models/failure.dart';
import 'package:viewstories/repositories/user/user_repository.dart';

part 'profile_collection_state.dart';

class ProfileCollectionCubit extends Cubit<ProfileCollectionState> {
  final UserRepository _userRepository;
  final AuthBloc _authBloc;

  late StreamSubscription<List<String?>> _collectionNamesSubs;

  ProfileCollectionCubit({
    required UserRepository userRepository,
    required AuthBloc authBloc,
  })  : _userRepository = userRepository,
        _authBloc = authBloc,
        super(ProfileCollectionState.initial()) {
    _collectionNamesSubs = _userRepository
        .streamUserStoryCollection(
            userID: _authBloc.state.user?.uid,
            collectionName: Paths.storiesList)
        .listen((names) {
      emit(ProfileCollectionState.loaded(collectionNames: names));
    });
  }

  void loadCollectionNames() async {
    final collNames = await _userRepository.getUserStoryCollection(
      userID: _authBloc.state.user?.uid,
      collectionName: Paths.feedList,
    );

    emit(ProfileCollectionState.loaded(collectionNames: collNames));
  }

  void collectionNameChanged({required String name}) {
    emit(state.copyWith(newColName: name));
  }

  void addToUserFeedCollection({
    required String collectionName,
    required String otherUserId,
  }) async {
    await _userRepository.addUseToFeed(
      currentUserId: _authBloc.state.user?.uid,
      otherUserId: otherUserId,
      collectionName: collectionName,
    );
  }

  @override
  Future<void> close() {
    _collectionNamesSubs.cancel();
    return super.close();
  }
}
