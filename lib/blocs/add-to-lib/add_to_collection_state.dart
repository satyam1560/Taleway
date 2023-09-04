part of 'add_to_collection_cubit.dart';

enum AddToCollectionStatus { initial, loading, succuss, error }

class AddToCollectionState extends Equatable {
  final AddToCollectionStatus status;
  final List<String?>? collectionNames;
  final Failure? failure;
  final String? name;

  const AddToCollectionState({
    required this.status,
    this.collectionNames = const [],
    this.failure,
    this.name,
  });

  factory AddToCollectionState.initial() => const AddToCollectionState(
        status: AddToCollectionStatus.initial,
        collectionNames: [],
        failure: Failure(),
      );

  factory AddToCollectionState.loaded({
    required List<String?> collectionNames,
  }) =>
      AddToCollectionState(
        status: AddToCollectionStatus.succuss,
        collectionNames: collectionNames,
        failure: const Failure(),
      );

  @override
  List<Object?> get props => [status, collectionNames, failure, name];

  AddToCollectionState copyWith({
    AddToCollectionStatus? status,
    List<String?>? collectionNames,
    Failure? failure,
    String? name,
  }) {
    return AddToCollectionState(
      status: status ?? this.status,
      collectionNames: collectionNames ?? this.collectionNames,
      failure: failure ?? this.failure,
      name: name ?? this.name,
    );
  }
}
