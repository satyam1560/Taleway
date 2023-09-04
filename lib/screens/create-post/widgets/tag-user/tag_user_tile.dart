import 'package:flutter/material.dart';
import '/models/app_user.dart';
import '/widgets/avatar_widget.dart';

class TagUserTile extends StatelessWidget {
  const TagUserTile({
    Key? key,
    required this.user,
    required this.onTap,
  }) : super(key: key);

  final AppUser? user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            AvatarWidget(
              imageUrl: user?.profilePic,
              size: 40.0,
            ),
            const SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.username ?? 'N/A',
                  style: const TextStyle(
                    color: Colors.white,
                    // fontWeight: FontWeight.w600,
                    //letterSpacing: 1.1,
                    fontSize: 15.0,
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
