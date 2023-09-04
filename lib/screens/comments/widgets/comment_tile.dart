import 'package:flutter/material.dart';
import '/extensions/extensions.dart';
import '/models/comment.dart';
import '/screens/comments/widgets/user_avatar.dart';

class CommentTile extends StatelessWidget {
  final Comment? comment;

  const CommentTile({
    Key? key,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: UserAvatar(
        imageUrl: comment?.author?.profilePic,
        size: 42.0,
      ),
      title: Text(
        comment?.author?.username ?? 'N/A',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.1,
          fontSize: 14.0,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      subtitle: Text(
        comment?.content ?? '',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15.0,
        ),
      ),
      trailing: Text(
        comment?.date.timeAgo() ?? 'N/A',
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 12.5,
        ),
      ),
    );
  }
}
