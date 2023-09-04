import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:viewstories/models/app_user.dart';
import 'package:viewstories/services/url_to_file.dart';

import '/blocs/auth/auth_bloc.dart';
import '/models/failure.dart';

import '/repositories/user/user_repository.dart';
part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final UserRepository _userRepository;

  final AuthBloc _authBloc;

  EditProfileCubit({
    required UserRepository userRepository,
    required AuthBloc authBloc,
  })  : _userRepository = userRepository,
        _authBloc = authBloc,
        super(EditProfileState.initail());

  void bioChanged(String value) {
    emit(state.copyWith(bio: value, status: EditProfileStatus.initial));
  }

  void nameChanged(String value) {
    emit(state.copyWith(name: value, status: EditProfileStatus.initial));
  }

  void imagePicked(Uint8List? image) {
    emit(state.copyWith(imageFile: image, status: EditProfileStatus.initial));
  }

  void editProfile() async {
    if (!state.isFormValid || state.status == EditProfileStatus.submitting) {
      return;
    }

    emit(state.copyWith(status: EditProfileStatus.submitting));
    try {
      print('Email ${state.name}');
      print('Password ${state.bio}');
      await _userRepository.editUserProfile(
        name: state.name,
        bio: state.bio,
        imageFile: state.imageFile,
        userId: _authBloc.state.user?.uid,
      );

      emit(state.copyWith(status: EditProfileStatus.succuss));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: EditProfileStatus.error));
    }
  }

  void loadUserProfile() async {
    try {
      emit(state.copyWith(status: EditProfileStatus.loading));
      final user = await _userRepository.getUserProfile(
          userId: _authBloc.state.user?.uid);

      final imageFile = await UrlToFileService.urlToFile(user?.profilePic);

      emit(
        state.copyWith(
          user: user,
          status: EditProfileStatus.initial,
          name: user?.name,
          bio: user?.bio,
          imageFile: await imageFile?.readAsBytes(),
        ),
      );
    } catch (error) {
      print('Error getting user ${error.toString()}');
    }
  }
}
