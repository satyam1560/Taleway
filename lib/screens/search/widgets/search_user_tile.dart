import 'package:flutter/material.dart';
import '/blocs/auth/auth_bloc.dart';
import '/screens/profile/profile_screen.dart';
import '/screens/others-profile/others_profile_screen.dart';
import '/models/app_user.dart';
import '/widgets/avatar_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchUserTile extends StatelessWidget {
  const SearchUserTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  final AppUser? user;

  @override
  Widget build(BuildContext context) {
    final _authBloc = context.read<AuthBloc>();

    return InkWell(
      onTap: () {
        if (_authBloc.state.user?.uid == user?.uid) {
          Navigator.of(context).pushNamed(ProfileScreen.routeName);
        } else {
          Navigator.of(context).pushNamed(
            OthersProfileScreen.routeName,
            arguments: OthersProfileScreenArgs(othersProfileId: user?.uid),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            AvatarWidget(imageUrl: user?.profilePic),
            const SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.username ?? 'N/A',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  user?.name ?? 'N/A',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
