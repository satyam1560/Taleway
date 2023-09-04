part of 'search_user_bloc.dart';

enum SearchUserStatus { initial, loading, loaded, paginating, error }

class SearchUserState extends Equatable {
  final List<AppUser?> recentUsers;
  final Failure failure;
  final SearchUserStatus status;

  const SearchUserState({
    required this.recentUsers,
    required this.failure,
    required this.status,
  });

  @override
  List<Object> get props => [recentUsers, failure, status];

  factory SearchUserState.initial() => const SearchUserState(
      recentUsers: [], failure: Failure(), status: SearchUserStatus.initial);

  factory SearchUserState.loaded({required List<AppUser?> users}) =>
      SearchUserState(
        recentUsers: users,
        status: SearchUserStatus.loaded,
        failure: const Failure(),
      );

  SearchUserState copyWith({
    List<AppUser?>? recentUsers,
    Failure? failure,
    SearchUserStatus? status,
  }) {
    return SearchUserState(
      recentUsers: recentUsers ?? this.recentUsers,
      failure: failure ?? this.failure,
      status: status ?? this.status,
    );
  }
}
