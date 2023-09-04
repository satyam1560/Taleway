import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '/screens/others-profile/bloc/others_profile_bloc.dart';

class BlockUserButton extends StatelessWidget {
  final bool isBlocked;
  const BlockUserButton({
    Key? key,
    required this.isBlocked,
  }) : super(key: key);

  Future<void> _blockUser(BuildContext context) async {
    try {
      var result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade800,
            title: Text(
              isBlocked ? 'Unblock User' : 'Block User',
              style: const TextStyle(color: Colors.white),
            ),
            content: Text(
              isBlocked
                  ? 'Do you want to unblock this user'
                  : 'Do you want to block this user ?',
              style: const TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    // color: Colors.red,
                    fontSize: 15.0,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'No',
                  style: TextStyle(
                    //color: Colors.green,
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
        if (isBlocked) {
          context.read<OthersProfileBloc>().add(UnBlockUser());
        } else {
          context.read<OthersProfileBloc>().add(BlockUser());
        }
      }
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async => _blockUser(context),
      icon: Icon(
        isBlocked ? Icons.lock_open_sharp : Icons.block,
        color: isBlocked ? Colors.white : Colors.redAccent,
        size: 20.0,
      ),
    );
  }
}
