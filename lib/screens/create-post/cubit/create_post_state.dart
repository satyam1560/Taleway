part of 'create_post_cubit.dart';

enum CreatePostStatus { initial, submitting, succuss, error }

// ignore: must_be_immutable
class CreatePostState extends Equatable {
  final String? caption;
  List<String?> tagUser;
  final String? location;
  final Uint8List? postImage;
  final CreatePostStatus status;
  final Failure failure;
  final String addToCollection;

  bool get isFormValid =>
      caption!.isNotEmpty &&
      // tagUser!.isNotEmpty &&
      location!.isNotEmpty &&
      postImage != null;

  CreatePostState({
    required this.caption,
    required this.tagUser,
    required this.location,
    required this.postImage,
    required this.status,
    required this.failure,
    required this.addToCollection,
  });

  CreatePostState copyWith({
    String? caption,
    List<String?>? tagUser,
    String? location,
    Uint8List? postImage,
    CreatePostStatus? status,
    Failure? failure,
    String? addToCollection,
  }) {
    return CreatePostState(
      caption: caption ?? this.caption,
      tagUser: tagUser ?? this.tagUser,
      location: location ?? this.location,
      postImage: postImage ?? this.postImage,
      status: status ?? this.status,
      failure: failure ?? this.failure,
      addToCollection: addToCollection ?? this.addToCollection,
    );
  }

  factory CreatePostState.initial() {
    return CreatePostState(
      caption: '',
      tagUser: const [],
      location: '',
      postImage: null,
      status: CreatePostStatus.initial,
      failure: const Failure(),
      // addToCollection: '',
      addToCollection: 'Close Friends',
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      caption,
      tagUser,
      location,
      postImage,
      status,
      failure,
      addToCollection,
    ];
  }
}
