part of 'profile_collection_cubit.dart';

enum ProfileCollectionStatus { initial, loading, succuss, error }

class ProfileCollectionState extends Equatable {
  final ProfileCollectionStatus status;
  final List<String?>? collectionNames;
  final Failure? failure;
  final String? newColName;

  const ProfileCollectionState({
    required this.status,
    this.collectionNames = const [],
    this.failure,
    this.newColName,
  });
  factory ProfileCollectionState.initial() => const ProfileCollectionState(
        status: ProfileCollectionStatus.initial,
        collectionNames: [],
        failure: Failure(),
      );

  factory ProfileCollectionState.loaded({
    required List<String?> collectionNames,
  }) =>
      ProfileCollectionState(
        status: ProfileCollectionStatus.succuss,
        collectionNames: collectionNames,
        failure: const Failure(),
      );

  @override
  List<Object?> get props => [status, collectionNames, failure, newColName];

  ProfileCollectionState copyWith({
    ProfileCollectionStatus? status,
    List<String?>? collectionNames,
    Failure? failure,
    String? newColName,
  }) {
    return ProfileCollectionState(
      status: status ?? this.status,
      collectionNames: collectionNames ?? this.collectionNames,
      failure: failure ?? this.failure,
      newColName: newColName ?? this.newColName,
    );
  }
}
