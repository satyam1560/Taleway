import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:equatable/equatable.dart';

import 'app_user.dart';

class Comment extends Equatable {
  final String? commentId;
  final String? storyId;
  final AppUser? author;
  final String? content;
  final DateTime date;

  const Comment({
    this.commentId,
    required this.storyId,
    required this.author,
    required this.content,
    required this.date,
  });

  @override
  List<Object?> get props => [
        commentId,
        storyId,
        author,
        content,
        date,
      ];

  Comment copyWith({
    String? commentId,
    String? storyId,
    AppUser? author,
    String? content,
    DateTime? date,
  }) {
    return Comment(
      commentId: commentId ?? this.commentId,
      storyId: storyId ?? this.storyId,
      author: author ?? this.author,
      content: content ?? this.content,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'postId': storyId,
      'author': FirebaseFirestore.instance.collection('users').doc(author?.uid),
      'content': content,
      'date': Timestamp.fromDate(date),
    };
  }

  static Future<Comment?> fromDocument(DocumentSnapshot? doc) async {
    if (doc == null) return null;
    final data = doc.data() as Map?;
    final authorRef = data?['author'] as DocumentReference?;
    if (authorRef != null) {
      final authorDoc = await authorRef.get();
      if (authorDoc.exists) {
        return Comment(
          commentId: doc.id,
          storyId: data?['postId'] ?? '',
          author: AppUser.fromDocument(authorDoc),
          content: data?['content'] ?? '',
          date: (data?['date'] as Timestamp).toDate(),
        );
      }
    }
    return null;
  }
}
