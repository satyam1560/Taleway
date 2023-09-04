import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viewstories/models/failure.dart';
import 'package:viewstories/utils/constants.dart';
import 'package:viewstories/widgets/gradient_circle_button.dart';
import 'package:viewstories/widgets/show_snackbar.dart';
import '/repositories/auth/auth_repo.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static const String routeName = '/forgetscreen';

  ForgotPasswordScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => ForgotPasswordScreen(),
    );
  }

  final _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _submitForm(BuildContext context) async {
    try {
      FocusScope.of(context).unfocus();
      if (_formKey.currentState!.validate()) {
        final _authRepo = context.read<AuthRepository>();
        await _authRepo.forgotPassword(_emailController.text);
        ShowSnackBar.showSnackBar(context, title: 'Please check your inbox');
        Navigator.of(context).pop();
      }
    } on Failure catch (error) {
      print('Failre on forget password ${error.toString()}');
      ShowSnackBar.showSnackBar(context, title: error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: gradientBackground,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 10.0,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60.0),
                    const Text(
                      'Taleway',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50.0),
                    const Text(
                      'Forgot password? ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 60.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: TextFormField(
                        style: const TextStyle(
                            color: Colors.white, fontSize: 16.0),
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        validator: (value) => !(value!.contains('@gmail.com'))
                            ? 'Invalid Email'
                            : null,
                        decoration: InputDecoration(
                          fillColor: const Color(0xff262626),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon:
                              const Icon(Icons.mail, color: Colors.white),
                          labelStyle: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 14.0,
                            letterSpacing: 1.0,
                          ),
                          hintText: 'Enter your email address',
                          hintStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      ' Please check your email to reset your password',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12.0,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Send code',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GradientCircleButton(
                          size: 52.0,
                          onTap: () => _submitForm(context),
                          icon: Icons.arrow_forward,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
