part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, succuss, error }

class ProfileState extends Equatable {
  final AppUser? appUser;
  final Failure failure;
  final ProfileStatus status;
  final List<String?> collectionName;
  final List<Story?> sectionStories;
  final String? newCollName;
  final List<Story?> todaysStories;

  const ProfileState({
    required this.appUser,
    required this.failure,
    required this.status,
    required this.collectionName,
    this.sectionStories = const [],
    this.newCollName,
    this.todaysStories = const [],
  });

  factory ProfileState.initial() {
    return const ProfileState(
      appUser: null,
      failure: Failure(),
      status: ProfileStatus.initial,
      collectionName: [],
      sectionStories: [],
      newCollName: null,
      todaysStories: [],
    );
  }

  factory ProfileState.loaded({
    required AppUser? appUser,
    required List<String?> cNames,
    required List<Story?> todayStories,
  }) {
    return ProfileState(
      appUser: appUser,
      failure: const Failure(),
      status: ProfileStatus.succuss,
      collectionName: cNames,
      todaysStories: todayStories,
    );
  }

  @override
  List<Object?> get props => [
        appUser,
        failure,
        status,
        collectionName,
        sectionStories,
        newCollName,
        todaysStories,
      ];

  ProfileState copyWith({
    AppUser? appUser,
    Failure? failure,
    ProfileStatus? status,
    List<String?>? collectionName,
    List<Story?>? sectionStories,
    String? newCollName,
    List<Story?>? todaysStories,
  }) {
    return ProfileState(
      appUser: appUser ?? this.appUser,
      failure: failure ?? this.failure,
      status: status ?? this.status,
      collectionName: collectionName ?? this.collectionName,
      sectionStories: sectionStories ?? this.sectionStories,
      newCollName: newCollName ?? this.newCollName,
      todaysStories: todaysStories ?? this.todaysStories,
    );
  }

  @override
  String toString() {
    return 'ProfileState(appUser: $appUser, failure: $failure, status: $status, collectionName: $collectionName, sectionStories: $sectionStories, todaysStoires: $todaysStories)';
  }
}
