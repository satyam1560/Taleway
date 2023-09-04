import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/config/paths.dart';
import '/blocs/auth/auth_bloc.dart';
import '/models/app_user.dart';
import '/models/failure.dart';
import '/repositories/user/user_repository.dart';

part 'others_profile_event.dart';
part 'others_profile_state.dart';

class OthersProfileBloc extends Bloc<OthersProfileEvent, OthersProfileState> {
  final String? _othersProfileId;
  final UserRepository _userRepository;
  final AuthBloc _authBloc;

  late StreamSubscription<AppUser?> _userSubscription;

  OthersProfileBloc({
    required String? otherProfileId,
    required UserRepository userRepository,
    required AuthBloc authBloc,
  })  : _othersProfileId = otherProfileId,
        _userRepository = userRepository,
        _authBloc = authBloc,
        super(OthersProfileState.initial()) {
    _userSubscription = _userRepository
        .streamUserProfile(userId: _othersProfileId)
        .listen((user) async {
      add(LoadOthersProfile());
    });

    on<OthersProfileEvent>((event, emit) async {
      if (event is LoadOthersProfile) {
        final user =
            await _userRepository.getUserProfile(userId: _othersProfileId);
        // print('User from others profile bloc $user');
        final stories = await _userRepository.getUserStoryCollection(
            userID: _othersProfileId, collectionName: Paths.storiesList);
        print('stories from others profile bloc $stories');

        final alreadyFollowed = await _userRepository.checkAlreadyFollowing(
          currentUserId: _authBloc.state.user?.uid,
          followUserId: _othersProfileId,
        );

        final isBlocked = await _userRepository.checkBlocked(
          currentUserId: _authBloc.state.user?.uid,
          otherUserId: _othersProfileId,
        );

        emit(
          OthersProfileState.loaded(
            appUser: user,
            cNames: stories,
            alreadyFollowed: alreadyFollowed,
            isBlocked: isBlocked,
          ),
        );

        // final user =
        //     await _userRepository.getUserProfile(userId: _othersProfileId);
        // print('User from others profile bloc $user');
        // final stories = await _userRepository.getUserStoryCollection(
        //     userID: _othersProfileId);
        // print('stories from others profile bloc $stories');

        // final alreadyFollowed = await _userRepository.checkAlreadyFollowing(
        //   currentUserId: _authBloc.state.user?.uid,
        //   followUserId: _othersProfileId,
        // );
        // emit(
        //   OthersProfileState.loaded(
        //     appUser: user,
        //     cNames: stories,
        //     alreadyFollowed: alreadyFollowed,
        //   ),
        // );
      } else if (event is FollowUser) {
        emit(state.copyWith(status: OthersProfileStatus.loading));
        await _userRepository.followUser(
          userId: _authBloc.state.user?.uid,
          followUserId: _othersProfileId,
        );

        // final alreadyFollowed = await _userRepository.checkAlreadyFollowing(
        //   currentUserId: _authBloc.state.user?.uid,
        //   followUserId: _othersProfileId,
        // );

        emit(
          OthersProfileState.loaded(
            appUser: state.user,
            cNames: state.collectionName,
            alreadyFollowed: true,
            isBlocked: state.isBlocked,
          ),
        );
      } else if (event is UnFollowUser) {
        emit(state.copyWith(status: OthersProfileStatus.loading));

        await _userRepository.unFollowUser(
          userId: _authBloc.state.user?.uid,
          unfollowUserId: _othersProfileId,
        );
        emit(
          OthersProfileState.loaded(
            appUser: state.user,
            cNames: state.collectionName,
            alreadyFollowed: false,
            isBlocked: state.isBlocked,
          ),
        );
      } else if (event is AddToUserFeedCollection) {
        await _userRepository.addUseToFeed(
          currentUserId: _authBloc.state.user?.uid,
          otherUserId: _othersProfileId,
          collectionName: 'Close Friends',
        );
      } else if (event is BlockUser) {
        await _userRepository.blockUser(
            currentUserId: _authBloc.state.user?.uid,
            otherUserId: _othersProfileId);
        // if we are blocking a user, we are also unflowing them
        add(UnFollowUser());
        emit(state.copyWith(isBlocked: true));
      } else if (event is UnBlockUser) {
        await _userRepository.unBlockUser(
            currentUserId: _authBloc.state.user?.uid,
            otherUserId: _othersProfileId);
        emit(state.copyWith(isBlocked: false));
      }
    });
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
