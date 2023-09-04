part of 'others_profile_bloc.dart';

enum OthersProfileStatus { initial, loading, succuss, error }

class OthersProfileState extends Equatable {
  final AppUser? user;
  final Failure? failure;
  final OthersProfileStatus status;
  final List<String?> collectionName;
  final bool alreadyFollowed;
  final bool isBlocked;

  const OthersProfileState({
    this.user,
    this.failure,
    required this.status,
    required this.collectionName,
    this.alreadyFollowed = false,
    this.isBlocked = false,
  });
  factory OthersProfileState.initial() {
    return const OthersProfileState(
      user: null,
      failure: Failure(),
      status: OthersProfileStatus.initial,
      collectionName: [],
      alreadyFollowed: false,
      isBlocked: false,
    );
  }

  factory OthersProfileState.loaded({
    required AppUser? appUser,
    required List<String?> cNames,
    required bool alreadyFollowed,
    required bool isBlocked,
  }) {
    return OthersProfileState(
      user: appUser,
      failure: const Failure(),
      status: OthersProfileStatus.succuss,
      collectionName: cNames,
      alreadyFollowed: alreadyFollowed,
      isBlocked: isBlocked,
    );
  }

  @override
  List<Object?> get props => [
        user,
        failure,
        status,
        collectionName,
        alreadyFollowed,
        isBlocked,
      ];

  OthersProfileState copyWith({
    AppUser? user,
    Failure? failure,
    OthersProfileStatus? status,
    List<String?>? collectionName,
    bool? alreadyFollowed,
    bool? isBlocked,
  }) {
    return OthersProfileState(
      user: user ?? this.user,
      failure: failure ?? this.failure,
      status: status ?? this.status,
      collectionName: collectionName ?? this.collectionName,
      alreadyFollowed: alreadyFollowed ?? this.alreadyFollowed,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }

  @override
  String toString() {
    return 'ProfileState(appUser: $user, failure: $failure, status: $status, collectionName: $collectionName, alreadyFollowed: $alreadyFollowed $isBlocked: isBlocked)';
  }
}
