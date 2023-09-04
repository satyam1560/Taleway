import 'package:viewstories/models/comment.dart';

abstract class BaseCommentRepository {
  Future<void> createComment({
    required Comment comment,
    required String? currentUserId,
    required String? storyAuthorId,
  });
  Future<void> deleteComment({
    required String? storyId,
    required String? commentId,
  });
}
