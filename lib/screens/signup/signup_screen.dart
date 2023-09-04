import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:url_launcher/url_launcher.dart';
import '/utils/constants.dart';
import '/widgets/loading_indicator.dart';
import '/widgets/gradient_circle_button.dart';
import '/utils/image_util.dart';
import '/widgets/custom_text_field.dart';
import '/widgets/error_dialog.dart';
import '/repositories/auth/auth_repo.dart';

import '/screens/signup/cubit/signup_cubit.dart';

class SignupScreen extends StatelessWidget {
  static const String routeName = '/signup';

  SignupScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<SignupCubit>(
        create: (context) => SignupCubit(
          authRepository: context.read<AuthRepository>(),
        ),
        child: SignupScreen(),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  Future<void> _launchInBrowser(String url) async {
    if (!await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      // headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
    }
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<SignupCubit>().signUpWithCredentials();
      // if (context.read<SignupCubit>().state.imageFile != null) {
      //   context.read<SignupCubit>().signUpWithCredentials();
      // } else {
      //   ShowSnackBar.showSnackBar(
      //     context,
      //     title: 'Please select an image to continue',
      //     //backgroundColor: Colors.red,
      //   );
      // }
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    final pickedImage = await ImageUtil.pickImageFromGallery(
      cropStyle: CropStyle.circle,
      context: context,
      imageQuality: 30,
      title: 'Pick profile pic',
    );

    context.read<SignupCubit>().imagePicked(await pickedImage?.readAsBytes());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: gradientBackground,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocConsumer<SignupCubit, SignupState>(
            listener: (context, state) {
              print('Current state ${state.status}');
              if (state.status == SignupStatus.error) {
                showDialog(
                  context: context,
                  builder: (context) => ErrorDialog(
                    content: state.failure.message,
                  ),
                );
              }
            },
            builder: (context, state) {
              return state.status == SignupStatus.submitting
                  ? const LoadingIndicator()
                  : Form(
                      key: _formKey,
                      child: ListView(
                        children: <Widget>[
                          const SizedBox(height: 30.0),
                          const Text(
                            'Taleway',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 30.0),
                          const Text(
                            'Create Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 30.0),

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
                                  icon: Icons.add,
                                ),
                              ],
                            ),
                          ), //GreetingsWidget(height: height),
                          const SizedBox(height: 20.0),

                          Padding(
                            padding: const EdgeInsets.only(
                                top: 22.0, left: 20.0, right: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                CustomTextField(
                                  textInputType: TextInputType.name,
                                  onChanged: (value) => context
                                      .read<SignupCubit>()
                                      .usernameChanged(value),
                                  validator: (value) => value!.isEmpty
                                      ? 'Username can\'t empty'
                                      : null,
                                  prefixIcon: Icons.account_circle,
                                  hintText: 'Username',
                                ),
                                CustomTextField(
                                  textInputType: TextInputType.name,
                                  onChanged: (value) => context
                                      .read<SignupCubit>()
                                      .emailChanged(value),
                                  validator: (value) =>
                                      !(value!.contains('@gmail.com'))
                                          ? 'Invalid Email'
                                          : null,
                                  prefixIcon: Icons.mail,
                                  hintText: 'Email',
                                ),
                                CustomTextField(
                                  textInputType: TextInputType.name,
                                  onChanged: (value) => context
                                      .read<SignupCubit>()
                                      .nameChanged(value),
                                  // validator: (value) => value!.isEmpty
                                  //     ? 'Name can\'t empty'
                                  //     : null,
                                  validator: (value) {
                                    return null;
                                  },
                                  prefixIcon: Icons.person,
                                  hintText: 'Full Name',
                                ),
                                CustomTextField(
                                  textInputType: TextInputType.text,
                                  onChanged: (value) => context
                                      .read<SignupCubit>()
                                      .bioChanged(value),
                                  // validator: (value) => value!.isEmpty
                                  //     ? 'Bio can\'t empty'
                                  //     : null,
                                  validator: (value) {
                                    return null;
                                  },
                                  prefixIcon: Icons.sentiment_satisfied_alt,
                                  hintText: 'Bio',
                                ),
                                CustomTextField(
                                  textInputType: TextInputType.visiblePassword,
                                  isPassowrdField: !state.showPassword,
                                  onChanged: (value) => context
                                      .read<SignupCubit>()
                                      .passwordChanged(value),
                                  validator: (value) => value!.length < 6
                                      ? 'Password too short'
                                      : null,
                                  suffixIcon: IconButton(
                                    color: Colors.white,
                                    icon: Icon(
                                      state.showPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      context
                                          .read<SignupCubit>()
                                          .showPassword(state.showPassword);
                                    },
                                  ),
                                  prefixIcon: Icons.lock,
                                  hintText: 'Password',
                                ),
                                Text.rich(
                                  TextSpan(
                                    // text: 'By clicking the ',
                                    children: <InlineSpan>[
                                      const TextSpan(text: ' By clicking the '),
                                      const TextSpan(
                                        text: 'Register',
                                        style: TextStyle(color: Colors.pink),
                                      ),
                                      const TextSpan(
                                          text: ' button you agree to the '),
                                      TextSpan(
                                        text: 'T&C ',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () =>
                                              _launchInBrowser(termsOfService),
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const TextSpan(text: '\n\nOur '),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () =>
                                              _launchInBrowser(privacyPolicy),
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    ],
                                  ),
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13.0,
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Sign Up',
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
                                                SignupStatus.submitting),
                                        icon: Icons.arrow_forward,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 35.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                ),
                              ),
                              const SizedBox(width: 5.0),
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16.0,
                                    letterSpacing: 1.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 14.0),
                        ],
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}

//  Container(
//   height: 200.0,
//   width: 200.0,
//   decoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(100.0),
//     gradient: LinearGradient(
//       begin: Alignment.center,
//       end: Alignment.bottomLeft,
//       stops: [
//         //    0.06, 0.5, 0.9, 2.0

//         0.8, 0.6, 0.8,
//       ],
//       colors: [
//         Colors.white10,
//         Colors.white54,
//         Colors.white54,
//       ],
//     ),
//   ),
// )

// CircleAvatar(
//   backgroundColor: Colors.white10.withOpacity(0.05),
//   radius: 100.0,
// ),


