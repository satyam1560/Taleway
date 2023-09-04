import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/blocs/auth/auth_bloc.dart';
import '/models/app_user.dart';
import '/models/failure.dart';
import '/repositories/user/user_repository.dart';

part 'followings_event.dart';
part 'followings_state.dart';

class FollowingsBloc extends Bloc<FollowingsEvent, FollowingsState> {
  final UserRepository _userRepository;
  final AuthBloc _authBloc;

  FollowingsBloc({
    required UserRepository userRepository,
    required AuthBloc authBloc,
  })  : _userRepository = userRepository,
        _authBloc = authBloc,
        super(FollowingsState.initial()) {
    on<FollowingsEvent>((event, emit) async {
      if (event is LoadFollowingsUsers) {
        emit(state.copyWith(status: FollowingsStatus.loading));
        final users = await _userRepository.getFollowingUsers(
            userId: _authBloc.state.user?.uid);

        print('List of foll users $users');

        emit(FollowingsState.loaded(users: users));
      }
    });
  }
}
