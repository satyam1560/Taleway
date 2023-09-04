part of 'edit_profile_cubit.dart';

enum EditProfileStatus { initial, loading, submitting, succuss, error }

class EditProfileState extends Equatable {
  final EditProfileStatus status;

  final String? name;
  final String? bio;
  final Uint8List? imageFile;
  final Failure failure;
  final AppUser? user;

  const EditProfileState({
    required this.status,
    required this.name,
    required this.bio,
    required this.imageFile,
    required this.failure,
    required this.user,
  });

  bool get isFormValid =>
      name!.isNotEmpty && bio!.isNotEmpty && imageFile != null;
  @override
  List<Object?> get props {
    return [
      status,
      name,
      bio,
      imageFile,
      failure,
      user,
    ];
  }

  EditProfileState copyWith({
    EditProfileStatus? status,
    String? name,
    String? bio,
    Uint8List? imageFile,
    Failure? failure,
    AppUser? user,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      imageFile: imageFile ?? this.imageFile,
      failure: failure ?? this.failure,
      user: user ?? user,
    );
  }

  factory EditProfileState.initail() => const EditProfileState(
        status: EditProfileStatus.initial,
        name: '',
        bio: '',
        imageFile: null,
        failure: Failure(),
        user: null,
      );

  @override
  bool get stringify => true;
}
