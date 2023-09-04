part of 'feed_bloc.dart';

enum FeedStatus { loading, initial, succuss, error }

class FeedState extends Equatable {
  final List<String?> collectionNames;
  final FeedStatus status;
  final String? newCollectionName;
  final AppUser? appUser;
  final Failure failure;

  const FeedState({
    required this.appUser,
    required this.failure,
    required this.status,
    required this.collectionNames,
    this.newCollectionName,
  });

  factory FeedState.initial() {
    return const FeedState(
      appUser: null,
      failure: Failure(),
      status: FeedStatus.initial,
      collectionNames: [],
    );
  }

  factory FeedState.loaded({
    required AppUser? appUser,
    required List<String?> cNames,
  }) {
    return FeedState(
      appUser: appUser,
      failure: const Failure(),
      status: FeedStatus.succuss,
      collectionNames: cNames,
    );
  }

  @override
  List<Object?> get props => [
        appUser,
        failure,
        status,
        collectionNames,
        newCollectionName,
      ];

  FeedState copyWith({
    AppUser? appUser,
    Failure? failure,
    FeedStatus? status,
    List<String?>? collectionNames,
    String? newCollectionName,
  }) {
    return FeedState(
      appUser: appUser ?? this.appUser,
      failure: failure ?? this.failure,
      status: status ?? this.status,
      collectionNames: collectionNames ?? this.collectionNames,
      newCollectionName: newCollectionName ?? this.newCollectionName,
    );
  }

  @override
  String toString() {
    return 'ProfileState(appUser: $appUser, failure: $failure, status: $status, collectionName: $collectionNames, newCollectionName: $newCollectionName)';
  }
}
