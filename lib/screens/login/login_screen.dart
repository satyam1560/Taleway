import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/utils/constants.dart';
import '/widgets/gradient_circle_button.dart';
import '/widgets/custom_text_field.dart';
import '/screens/forget-password/forget_password_screen.dart';
import '/screens/signup/signup_screen.dart';
import '/repositories/auth/auth_repo.dart';
import '/widgets/error_dialog.dart';
import '/widgets/loading_indicator.dart';
import '/screens/login/cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  LoginScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<LoginCubit>(
        create: (_) =>
            LoginCubit(authRepository: context.read<AuthRepository>()),
        child: LoginScreen(),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitForm(BuildContext context, bool isSubmitting) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<LoginCubit>().signInWithEmail();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _canvas = MediaQuery.of(context).size;

    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Colors.black54,

    //     statusBarIconBrightness: Brightness.light,
    //   ),
    // );
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.error) {
            showDialog(
              context: context,
              builder: (context) => ErrorDialog(
                content: state.failure.message,
              ),
            );
          }
          //  else if (state.status == LoginStatus.succuss) {
          //   ShowSnackBar.showSnackBar(context, title: 'Login Succussfull');
          // }
        },
        builder: (context, state) {
          return Container(
            decoration: gradientBackground,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: state.status == LoginStatus.submitting
                  ? const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: LoadingIndicator(),
                    )
                  : GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 22.0, left: 20.0, right: 20.0),
                        child: Form(
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
                              const SizedBox(height: 40.0),
                              const Text(
                                '"Tell your story in your story"',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontStyle: FontStyle.italic,
                                  //fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 50.0),
                              const Text(
                                'Welcome',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 30.0),
                              //  SizedBox(height: height < 750 ? 15.0 : 12.0),
                              CustomTextField(
                                textInputType: TextInputType.emailAddress,
                                onChanged: (value) => context
                                    .read<LoginCubit>()
                                    .emailChanged(value),
                                validator: (value) =>
                                    !(value!.contains('@gmail.com'))
                                        ? 'Invalid Email'
                                        : null,
                                hintText: 'Email',
                                prefixIcon: Icons.mail,
                              ),
                              CustomTextField(
                                textInputType: TextInputType.visiblePassword,
                                isPassowrdField: !state.showPassword,
                                onChanged: (value) => context
                                    .read<LoginCubit>()
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
                                          .read<LoginCubit>()
                                          .showPassword(state.showPassword);
                                    }),
                                prefixIcon: Icons.lock,
                                hintText: 'Password',
                              ),
                              Container(
                                alignment: const Alignment(1.0, 0.0),
                                padding: const EdgeInsets.only(
                                    top: 10.0, left: 20.0),
                                child: InkWell(
                                  onTap: () => Navigator.pushNamed(
                                      context, ForgotPasswordScreen.routeName),
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: Colors.pink,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.9,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40.0),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Sign In',
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
                                              LoginStatus.submitting),
                                      icon: Icons.arrow_forward,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: _canvas.height * 0.2),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Text(
                                    'Need an account?',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.white,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  const SizedBox(width: 5.0),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, SignupScreen.routeName);
                                    },
                                    child: const Text(
                                      'Register',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontFamily: 'Montserrat',
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 20.0),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
