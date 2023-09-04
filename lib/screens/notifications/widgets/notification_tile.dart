import 'package:flutter/material.dart';
import '/screens/comments/comments_screen.dart';
import '/screens/others-profile/others_profile_screen.dart';
import '/extensions/extensions.dart';
import '/widgets/avatar_widget.dart';
import '/models/notif.dart';

class NotificationTile extends StatelessWidget {
  final Notif? notification;

  const NotificationTile({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Notif -- $notification');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: GestureDetector(
        onTap: () {
          if (notification?.type == NotifType.like ||
              notification?.type == NotifType.comment) {
            Navigator.of(context).pushNamed(
              CommentsScreen.routeName,
              arguments: CommentsScreenArgs(
                storyId: notification?.story?.storyId,
                storyAuthorId: notification?.story?.author?.uid,
              ),
            );
          } else if (notification?.type == NotifType.follow) {
            Navigator.of(context).pushNamed(
              OthersProfileScreen.routeName,
              arguments: OthersProfileScreenArgs(
                  othersProfileId: notification?.fromUser?.uid),
            );
          }
        },
        child: Row(
          children: [
            AvatarWidget(
              imageUrl: notification?.fromUser?.profilePic,
              size: 50.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: notification?.fromUser?.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                        ),
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: _getText(notification),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Text(
                  //   '${notification?.fromUser?.username}',
                  //   style: const TextStyle(color: Colors.white),
                  // ),
                  const SizedBox(height: 5.0),
                  Text(
                    notification?.date != null
                        ? notification!.date.timeAgo()
                        : 'N/A',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String _getText(Notif? notification) {
    switch (notification?.type) {
      case NotifType.like:
        return 'liked your post.';
      case NotifType.comment:
        return 'commented on your post.';
      case NotifType.follow:
        return 'followed you.';
      default:
        return '';
    }
  }
}
