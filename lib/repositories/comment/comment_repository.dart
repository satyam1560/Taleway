import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/story.dart';
import '/config/paths.dart';
import '/models/comment.dart';
import '/models/notif.dart';
import '/repositories/comment/base_comment_repo.dart';
import 'package:cloud_functions/cloud_functions.dart';

class CommentsRepository extends BaseCommentRepository {
  CommentsRepository({FirebaseFirestore? firestore})
      : _fireStore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _fireStore;

  @override
  Future<void> createComment({
    required Comment comment,
    required String? currentUserId,
    required String? storyAuthorId,
  }) async {
    try {
      _fireStore
          .collection(Paths.comments)
          .doc(comment.storyId)
          .collection(Paths.storyComments)
          .add(comment.toDocument());

      if (currentUserId != storyAuthorId) {
        final notification = Notif(
          type: NotifType.comment,
          fromUser: comment.author,
          story: Story(
            storyId: comment.storyId,
            date: null,
            collectionName: null,
            expireAt: null,
          ),
          date: DateTime.now(),
        );

        _fireStore
            .collection(Paths.notifications)
            .doc(storyAuthorId)
            .collection(Paths.userNotifications)
            .add(notification.toDocument());
        if (currentUserId != storyAuthorId) {
          // we will not send notification to ourself, if we comment on out own post
          await sendCommentNotification(
            authorId: currentUserId,
            storyAuthorId: storyAuthorId,
            storyId: comment.storyId,
          );
        }
      }
    } catch (error) {
      print('Error in adding comments ${error.toString()}');
      rethrow;
    }
  }

  Future<void> sendCommentNotification({
    required String? authorId,
    required String? storyAuthorId,
    required String? storyId,
  }) async {
    try {
      if (authorId == null || storyAuthorId == null || storyId == null) {
        return;
      }
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('onComment');

      final resp = await callable.call(<String, dynamic>{
        'authorId': authorId,
        'storyAuthorId': storyAuthorId,
        'storyId': storyId,
      });
      print('result: ${resp.data}');
    } catch (error) {
      print('Error in sending comment notification ${error.toString()}');
    }
  }

  @override
  Future<void> deleteComment({
    required String? storyId,
    required String? commentId,
  }) async {
    try {
      await _fireStore
          .collection(Paths.comments)
          .doc(storyId)
          .collection(Paths.storyComments)
          .doc(commentId)
          .delete();
    } catch (error) {
      print('Error deleting comment ${error.toString()}');
      rethrow;
    }
  }

  Stream<List<Future<Comment?>>> getPostComments({required String? storyId}) {
    return _fireStore
        .collection(Paths.comments)
        .doc(storyId)
        .collection(Paths.storyComments)
        .orderBy('date', descending: false)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => Comment.fromDocument(doc)).toList());
  }
}
