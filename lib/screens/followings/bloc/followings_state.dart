part of 'followings_bloc.dart';

enum FollowingsStatus { intial, loading, succuss, error }

class FollowingsState extends Equatable {
  final List<AppUser?> users;
  final FollowingsStatus status;
  final Failure failure;
  const FollowingsState({
    required this.users,
    required this.status,
    required this.failure,
  });

  @override
  List<Object?> get props => [users, status, failure];

  factory FollowingsState.initial() => const FollowingsState(
        users: [],
        status: FollowingsStatus.intial,
        failure: Failure(),
      );

  factory FollowingsState.loaded({required List<AppUser?> users}) =>
      FollowingsState(
        users: users,
        status: FollowingsStatus.succuss,
        failure: const Failure(),
      );

  FollowingsState copyWith({
    List<AppUser?>? users,
    FollowingsStatus? status,
    Failure? failure,
  }) {
    return FollowingsState(
      users: users ?? this.users,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
