import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/models/app_user.dart';
import '/models/failure.dart';
import '/repositories/user/user_repository.dart';

part 'search_user_event.dart';
part 'search_user_state.dart';

class SearchUserBloc extends Bloc<SearchUserEvent, SearchUserState> {
  final UserRepository _userRepository;

  SearchUserBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(SearchUserState.initial()) {
    on<SearchUserEvent>((event, emit) async {
      if (event is LoadRecentUsers) {
        try {
          // final users = await _userRepository.getNewUsers();

          final users = await _userRepository.getRecentUsers();
          emit(state.copyWith(
              recentUsers: users, status: SearchUserStatus.loaded));
        } catch (error) {
          print('Error getting users  --- ${error.toString()}');
          emit(state.copyWith(
              failure: const Failure(message: 'Error getting recent users')));
        }
      } else if (event is PaginateRecentUsers) {
        emit(state.copyWith(status: SearchUserStatus.paginating));
        try {
          final lastUserId =
              state.recentUsers.isNotEmpty ? state.recentUsers.last?.uid : null;

          final users =
              await _userRepository.getNewUsers(lastUserId: lastUserId);

          final updatedUsers = List<AppUser?>.from(state.recentUsers)
            ..addAll(users);

          emit(state.copyWith(
              recentUsers: updatedUsers, status: SearchUserStatus.loaded));
        } catch (error) {
          print('Error in paginating posts ${error.toString()}');
        }
      }
    });
  }
}
