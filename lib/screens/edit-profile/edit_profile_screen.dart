import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:viewstories/utils/constants.dart';
import '/widgets/loading_indicator.dart';
import '/screens/edit-profile/cubit/edit_profile_cubit.dart';
import '/widgets/custom_appbar.dart';
import '/blocs/auth/auth_bloc.dart';
import '/repositories/user/user_repository.dart';
import '/widgets/show_snackbar.dart';
import '/widgets/gradient_circle_button.dart';
import '/utils/image_util.dart';
import '/widgets/custom_text_field.dart';
import '/widgets/error_dialog.dart';

class EditProfleScreen extends StatelessWidget {
  static const String routeName = '/edit-profile';

  EditProfleScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<EditProfileCubit>(
        create: (context) => EditProfileCubit(
            userRepository: context.read<UserRepository>(),
            authBloc: context.read<AuthBloc>())
          ..loadUserProfile(),
        child: EditProfleScreen(),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  void _submitForm(BuildContext context, bool isSubmitting) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate() && !isSubmitting) {
      if (context.read<EditProfileCubit>().state.imageFile != null) {
        context.read<EditProfileCubit>().editProfile();
      } else {
        ShowSnackBar.showSnackBar(
          context,
          title: 'Please select an image to continue',
          //backgroundColor: Colors.red,
        );
      }
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    final pickedImage = await ImageUtil.pickImageFromGallery(
        cropStyle: CropStyle.circle,
        context: context,
        title: 'Pick profile pic');

    context
        .read<EditProfileCubit>()
        .imagePicked(await pickedImage?.readAsBytes());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: gradientBackground,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: BlocConsumer<EditProfileCubit, EditProfileState>(
              listener: (context, state) {
                print('Current state ${state.status}');
                if (state.status == EditProfileStatus.error) {
                  showDialog(
                    context: context,
                    builder: (context) => ErrorDialog(
                      content: state.failure.message,
                    ),
                  );
                } else if (state.status == EditProfileStatus.succuss) {
                  Navigator.of(context).pop(true);
                }
              },
              builder: (context, state) {
                return state.status == EditProfileStatus.submitting ||
                        state.status == EditProfileStatus.loading
                    ? const LoadingIndicator()
                    : Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 25.0,
                          ),
                          child: ListView(
                            children: <Widget>[
                              const CustomAppBar(title: 'Edit Profile'),
                              const SizedBox(height: 50.0),
                              Center(
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    CircleAvatar(
                                      radius: 50.0,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        backgroundImage: state.imageFile != null
                                            ? MemoryImage(state.imageFile!,
                                                scale: 0.3)
                                            : null,
                                        radius: 48.0,
                                        backgroundColor: primaryColor,
                                        child: state.imageFile == null
                                            ? const Icon(
                                                Icons.person,
                                                color: Colors.white,
                                                size: 30.0,
                                              )
                                            : null,
                                      ),
                                    ),
                                    GradientCircleButton(
                                      size: 40.0,
                                      onTap: () async => _pickImage(context),
                                      icon: Icons.edit,
                                      iconSize: 20.0,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              const Text(
                                'Change profile photo',
                                style: TextStyle(color: Colors.white54),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 25.0),
                              CustomTextField(
                                initialValue: state.user?.name,
                                textInputType: TextInputType.name,
                                onChanged: (value) => context
                                    .read<EditProfileCubit>()
                                    .nameChanged(value),
                                validator: (value) =>
                                    value!.isEmpty ? 'Name can\'t empty' : null,
                                prefixIcon: Icons.person,
                                hintText: 'Name',
                              ),
                              CustomTextField(
                                initialValue: state.user?.bio,
                                textInputType: TextInputType.name,
                                onChanged: (value) => context
                                    .read<EditProfileCubit>()
                                    .bioChanged(value),
                                validator: (value) =>
                                    value!.isEmpty ? 'Bio can\'t empty' : null,
                                prefixIcon: Icons.sentiment_satisfied_alt,
                                hintText: 'Bio',
                              ),
                              const SizedBox(height: 20.0),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Confirm',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    GradientCircleButton(
                                      size: 52.0,
                                      onTap: () => _submitForm(
                                          context,
                                          state.status ==
                                              EditProfileStatus.submitting),
                                      icon: Icons.arrow_forward,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 35.0),
                            ],
                          ),
                        ),
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}
