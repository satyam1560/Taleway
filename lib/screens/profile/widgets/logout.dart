import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viewstories/widgets/gradient_circle_button.dart';
import '/blocs/auth/auth_bloc.dart';

class Logout extends StatelessWidget {
  const Logout({Key? key}) : super(key: key);

  Future<void> _signOutUser(BuildContext context) async {
    try {
      var result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade800,
            title: const Text(
              'SignOut',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Do you want to signOut ?',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 15.0,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'No',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ],
          );
        },
      );

      final bool logout = await result ?? false;
      if (logout) {
        BlocProvider.of<AuthBloc>(context).add(AuthLogoutRequested());
      }
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientCircleButton(
      onTap: () async => _signOutUser(context),
      icon: Icons.logout,
      iconSize: 20.0,
      size: 35.0,
    );
  }
}
