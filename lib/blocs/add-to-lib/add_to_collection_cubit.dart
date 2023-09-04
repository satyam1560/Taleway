import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '/blocs/auth/auth_bloc.dart';
import '/config/paths.dart';

import '/models/failure.dart';
import '/repositories/user/user_repository.dart';

part 'add_to_collection_state.dart';

class AddToCollectionCubit extends Cubit<AddToCollectionState> {
  final UserRepository _userRepository;
  final AuthBloc _authBloc;

  late StreamSubscription<List<String?>> _collectionNamesSubs;

  AddToCollectionCubit({
    required UserRepository userRepository,
    required AuthBloc authBloc,
  })  : _userRepository = userRepository,
        _authBloc = authBloc,
        super(AddToCollectionState.initial()) {
    _collectionNamesSubs = _userRepository
        .streamUserStoryCollection(
            userID: _authBloc.state.user?.uid, collectionName: Paths.feedList)
        .listen((names) {
      emit(AddToCollectionState.loaded(collectionNames: names));
    });
  }

  void loadCollectionNames() async {
    final collNames = await _userRepository.getUserStoryCollection(
      userID: _authBloc.state.user?.uid,
      collectionName: Paths.feedList,
    );

    emit(AddToCollectionState.loaded(collectionNames: collNames));
  }

  void collectionNameChanged({required String name}) {
    emit(state.copyWith(name: name));
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
