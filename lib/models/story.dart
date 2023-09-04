import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:viewstories/models/tag_user.dart';
import '/config/paths.dart';
import '/models/app_user.dart';

class Story extends Equatable {
  final String? storyUrl;
  final AppUser? author;
  final List<TagUser?>? taggedUser;
  final String? location;
  final String? caption;
  final String? storyId;
  final DateTime? date;
  final String? collectionName;
  final DateTime? expireAt;

  const Story({
    this.storyUrl,
    this.author,
    this.taggedUser,
    this.location,
    this.caption,
    this.storyId,
    required this.date,
    required this.collectionName,
    required this.expireAt,
  });

  Story copyWith({
    String? storyUrl,
    AppUser? author,
    List<TagUser?>? taggedUser,
    String? location,
    String? caption,
    String? storyId,
    DateTime? date,
    String? collectionName,
    DateTime? expireAt,
  }) {
    return Story(
      storyUrl: storyUrl ?? this.storyUrl,
      author: author ?? this.author,
      taggedUser: taggedUser ?? this.taggedUser,
      location: location ?? this.location,
      caption: caption ?? this.caption,
      storyId: storyId ?? this.storyId,
      date: date ?? this.date,
      collectionName: collectionName ?? this.collectionName,
      expireAt: expireAt ?? this.expireAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'storyUrl': storyUrl,
      'author':
          FirebaseFirestore.instance.collection(Paths.users).doc(author?.uid),
      // 'taggedUser': taggedUser?.map((x) => x?.toMap())?.toList(),
      // 'taggedUser': taggedUser,
      'location': location,
      'caption': caption,
      //'storyId': storyId,
      'date': date != null ? Timestamp.fromDate(date!) : null,
      'collectionName': collectionName,
      'expireAt': expireAt != null ? Timestamp.fromDate(expireAt!) : null
    };
  }

  static Future<Story?> fromDocument(DocumentSnapshot? doc) async {
    if (doc == null) return null;
    final taggedUsers = await FirebaseFirestore.instance
        .collection(Paths.stories)
        .doc(doc.id)
        .collection('taggedUsers')
        .get();

    final data = doc.data() as Map<String, dynamic>?;
    print('Story data ------- $data');
    if (data != null) {
      final authorRef = data['author'] as DocumentReference?;
      // if (authorRef != null) {
      print('Author ref --- $authorRef');

      final authorDoc = await authorRef?.get();
      print('Author doc ------- $authorDoc');
      return Story(
        author: data['author'] != null ? AppUser.fromDocument(authorDoc) : null,
        location: data['location'],
        caption: data['caption'],
        //storyId: data['storyId'],
        storyId: doc.id,
        date:
            data['date'] != null ? (data['date'] as Timestamp).toDate() : null,
        taggedUser:
            taggedUsers.docs.map((doc) => TagUser(userId: doc.id)).toList(),

        //  data['taggedUser'] != null
        //     ? List<String?>.from(data['taggedUser']?.map((x) => x.toString()))
        //     : [],
        storyUrl: data['storyUrl'],
        collectionName: data['collectionName'],
        expireAt: data['expireAt'] != null
            ? (data['expireAt'] as Timestamp).toDate()
            : null,
      );
      // }
    }
    return null;
  }

  // static Future<Story?> formMap(Map<String, dynamic>? map) async {
  //   if (map == null) {
  //     return null;
  //   }
  //   if (doc == null) return null;
  //   final taggedUsers = await FirebaseFirestore.instance
  //       .collection(Paths.stories)
  //       .doc(doc.id)
  //       .collection('taggedUsers')
  //       .get();

  //   final data = doc.data() as Map<String, dynamic>?;
  //   print('Story data ------- $data');
  //   if (data != null) {
  //     final authorRef = data['author'] as DocumentReference?;
  //     // if (authorRef != null) {
  //     print('Author ref --- $authorRef');

  //     final authorDoc = await authorRef?.get();
  //     print('Author doc ------- $authorDoc');
  //     return Story(
  //       author: data['author'] != null ? AppUser.fromDocument(authorDoc) : null,
  //       location: data['location'],
  //       caption: data['caption'],
  //       //storyId: data['storyId'],
  //       storyId: doc.id,
  //       date:
  //           data['date'] != null ? (data['date'] as Timestamp).toDate() : null,
  //       taggedUser:
  //           taggedUsers.docs.map((doc) => TagUser(userId: doc.id)).toList(),

  //       //  data['taggedUser'] != null
  //       //     ? List<String?>.from(data['taggedUser']?.map((x) => x.toString()))
  //       //     : [],
  //       storyUrl: data['storyUrl'],
  //       collectionName: data['collectionName'],
  //       expireAt: data['expireAt'] != null
  //           ? (data['expireAt'] as Timestamp).toDate()
  //           : null,
  //     );
  //     // }
  //   }
  //   return null;
  // }

  // factory Story.fromMap(Map<String, dynamic> map) {
  //   print('Tagged User ---- ${map['taggedUser']}');
  //   print('Tagged User ---- ${map['taggedUser'].runtimeType}');
  //   return Story(
  //     storyUrl: map['storyUrl'],
  //     author: map['authorId'],
  //     taggedUser: map['taggedUser'] != null
  //         ? List<String?>.from(map['taggedUser']?.map((x) => x.toString()))
  //         : [],
  //     location: map['location'],
  //     caption: map['caption'],
  //     storyId: map['storyId'],
  //   );
  // }

  String toJson() => json.encode(toMap());

  // factory Story.fromJson(String source) => Story.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Story(storyUrl: $storyUrl, author: $author, taggedUser: $taggedUser, location: $location, caption: $caption, storyId: $storyId, data: $date)';
  }

  @override
  List<Object?> get props {
    return [
      storyUrl,
      author,
      taggedUser,
      location,
      caption,
      storyId,
      date,
      collectionName,
      expireAt
    ];
  }
}
