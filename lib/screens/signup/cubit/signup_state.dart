part of 'signup_cubit.dart';

enum SignupStatus { initial, submitting, succuss, error }

class SignupState extends Equatable {
  final String? email;
  final String? name;
  final String? username;
  final String? password;
  final Uint8List? imageFile;
  final SignupStatus status;
  final Failure failure;
  final String? uid;
  final String? bio;

  final bool showPassword;

  // bool get isFormValid =>
  //     email!.isNotEmpty &&
  //     password!.isNotEmpty &&
  //     username!.isNotEmpty &&
  //     imageFile != null;

  bool get isFormValid => email!.isNotEmpty && password!.isNotEmpty;
  //&&
  // username!.isNotEmpty &&
  //  imageFile != null;

  const SignupState({
    required this.email,
    required this.password,
    required this.status,
    required this.failure,
    required this.name,
    required this.username,
    required this.showPassword,
    required this.imageFile,
    required this.uid,
    required this.bio,
  });

  factory SignupState.initial() {
    return const SignupState(
      email: '',
      password: '',
      name: '',
      username: '',
      status: SignupStatus.initial,
      failure: Failure(),
      showPassword: false,
      imageFile: null,
      uid: '',
      bio: '',
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        email,
        password,
        status,
        failure,
        showPassword,
        name,
        username,
        imageFile,
        uid,
        bio,
      ];

  SignupState copyWith({
    String? email,
    String? name,
    String? username,
    String? password,
    SignupStatus? status,
    Failure? failure,
    bool? showPassword,
    Uint8List? imageFile,
    String? uid,
    String? bio,
  }) {
    return SignupState(
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      failure: failure ?? this.failure,
      imageFile: imageFile ?? this.imageFile,
      showPassword: showPassword ?? this.showPassword,
      uid: uid ?? this.uid,
      bio: bio ?? this.bio,
    );
  }
}
