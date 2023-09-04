import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/app_user.dart';
import '/models/story.dart';
import '/config/paths.dart';
import '/repositories/feed/base_feed_repository.dart';

class FeedRepository extends BaseFeedRepository {
  final FirebaseFirestore _firestore;

  FeedRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<Future<Story?>>> streamFeedStories({
    required String? userId,
    required String collectionName,
  }) {
    try {
      // final authorRef = _firestore.collection(Paths.users).doc(userId);

      print('Collection name ---- $collectionName');
      return _firestore
          .collection(Paths.stories)
          .doc(userId)
          .collection(collectionName)
          .snapshots()
          .map((snap) =>
              snap.docs.map((doc) => Story.fromDocument(doc)).toList());
    } catch (error) {
      print('Error getting users stories ${error.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> deleteUserFeedCollectin({
    required String? userId,
    required String? collectionName,
  }) async {
    try {
      await _firestore
          .collection(Paths.users)
          .doc(userId)
          .collection(Paths.feedList)
          .doc(collectionName)
          .delete();
    } catch (error) {
      print('Error in delte user ${error.toString()}');
      rethrow;
    }
  }

  // Future<List<Future<AppUser?>>> collectionUsers({
  //   required String? userId,
  //   required String? collectionName,
  //   String? lastDocId,
  // }) async {
  //   try {
  //     if (userId == null && collectionName == null) {
  //       return [];
  //     }

  //     QuerySnapshot userSnaps;

  //     if (lastDocId == null) {
  //       userSnaps = await _firestore
  //           .collection(Paths.feed)
  //           .doc(userId)
  //           .collection(Paths.users)
  //           .where('collectionName', isEqualTo: collectionName)
  //           .limit(4)
  //           .get();
  //     } else {
  //       final lastUserDoc = await _firestore
  //           .collection(Paths.feed)
  //           .doc(userId)
  //           .collection(Paths.users)
  //           .doc(lastDocId)
  //           .get();

  //       if (!lastUserDoc.exists) {
  //         return [];
  //       }

  //       userSnaps = await _firestore
  //           .collection(Paths.feed)
  //           .doc(userId)
  //           .collection(Paths.users)
  //           .where('collectionName', isEqualTo: collectionName)
  //           .startAfterDocument(lastUserDoc)
  //           .limit(4)
  //           .get();
  //     }

  //     // final userSnaps = await _firestore
  //     //     .collection(Paths.feed)
  //     //     .doc(userId)
  //     //     .collection(Paths.users)
  //     //     .where('collectionName', isEqualTo: collectionName)
  //     //     .get();

  //     return userSnaps.docs.map((doc) async {
  //       final userDoc =
  //           await _firestore.collection(Paths.users).doc(doc.id).get();
  //       return AppUser.fromDocument(userDoc);
  //     }).toList();

  //     //return userSnaps.docs.map((doc) => AppUser.fromDocument(doc)).toList();
  //   } catch (error) {
  //     print('Error getting collection users ${error.toString()}');
  //     rethrow;
  //   }
  // }

  Future<List<Future<AppUser?>>> collectionUsers({
    required String? userId,
    required String? collectionName,
  }) async {
    try {
      if (userId == null && collectionName == null) {
        return [];
      }
      final userSnaps = await _firestore
          .collection(Paths.feed)
          .doc(userId)
          .collection(Paths.users)
          .where('collectionName', isEqualTo: collectionName)
          .get();

      return userSnaps.docs.map((doc) async {
        final userDoc =
            await _firestore.collection(Paths.users).doc(doc.id).get();
        return AppUser.fromDocument(userDoc);
      }).toList();

      //return userSnaps.docs.map((doc) => AppUser.fromDocument(doc)).toList();
    } catch (error) {
      print('Error getting collection users ${error.toString()}');
      rethrow;
    }
  }

  // Future<List<Story?>> getFeed({
  //   required String? collectionName,
  //   required String? userId,
  // }) async {
  //   try {
  //     List<Story?> stories = [];
  //     print('User id - $userId');

  //     final userSnaps = await _firestore
  //         .collection(Paths.feed)
  //         .doc(userId)
  //         .collection(Paths.users)
  //         .where('collectionName', isEqualTo: collectionName)
  //         //.orderBy('date', descending: true)
  //         .get();

  //     print('User snaps ----- ${userSnaps.docs}');

  //     for (var element in userSnaps.docs) {
  //       print('Element id ----- ${element.id}');
  //       final storyDocs =
  //           await _firestore.collection(Paths.stories).doc(element.id).get();
  //       if (storyDocs.exists) {
  //         print('Story docs -----${storyDocs.exists}');
  //         final story = await Story.fromDocument(storyDocs);
  //         print('Feed stories ------- $story');
  //         stories.add(story);
  //       }
  //     }
  //     return stories;
  //   } catch (error) {
  //     print('Error getting feed ${error.toString()}');
  //     rethrow;
  //   }
  // }

  // Future<List<List<Future<Story?>>>> getFeed({
  //   required String? collectionName,
  //   required String? userId,
  // }) async {
  //   try {
  //     List<List<Future<Story?>>> stories = [];
  //     print('User id - $userId');

  //     final userSnaps = await _firestore
  //         .collection(Paths.feed)
  //         .doc(userId)
  //         .collection(Paths.users)
  //         .where('collectionName', isEqualTo: collectionName)
  //         //.orderBy('date', descending: true)
  //         .get();

  //     print('User snaps ----- ${userSnaps.docs}');

  //     for (var element in userSnaps.docs) {
  //       print('Element id ----- ${element.id}');

  //       final storiesSnaps = await _firestore
  //           .collection(Paths.stories)
  //           .doc(element.id)
  //           .collection(Paths.userStories)
  //           .where('expireAt',
  //               isGreaterThan: Timestamp.fromDate(DateTime.now()))
  //           .get();

  //       stories.add(
  //           storiesSnaps.docs.map((snap) => Story.fromDocument(snap)).toList());

  //       // final storyDocs =
  //       //     await _firestore.collection(Paths.stories).doc(element.id).get();
  //       // if (storyDocs.exists) {
  //       //   print('Story docs -----${storyDocs.exists}');
  //       //   final story = await Story.fromDocument(storyDocs);
  //       //   print('Feed stories ------- $story');
  //       //   stories.add(story);
  //       // }
  //     }
  //     return stories;
  //   } catch (error) {
  //     print('Error getting feed ${error.toString()}');
  //     rethrow;
  //   }
  // }

  Future<List<Story?>> getFeedStories({
    required String? collectionName,
    required String? userId,
  }) async {
    try {
      List<Story?> stories = [];
      final userSnaps = await _firestore
          .collection(Paths.feed)
          .doc(userId)
          .collection('users')
          .where('collectionName', isEqualTo: collectionName)
          .orderBy('date', descending: true)
          .get();

      for (var element in userSnaps.docs) {
        final docSnap =
            await _firestore.collection(Paths.stories).doc(element.id).get();

        print('Story document snapshot $docSnap');
        final data = docSnap.data();
        if (data != null) {
          //stories.add(Story.fromMap(data));
        }
      }

      return stories;
    } catch (error) {
      print('Error getting feed user ${error.toString()}');
      rethrow;
    }
  }

  Future<List<String?>> getUserFeedCollection({
    required String? userID,
  }) async {
    try {
      final snapshot = await _firestore
          .collection(Paths.users)
          .doc(userID)
          .collection(Paths.feedList)
          .orderBy('date', descending: true)
          .get();

      // for (var element in snapshot.docs) {
      //   storiesList.add(element.id);
      // }

      return snapshot.docs.map((doc) => doc.id).toList();
      // return storiesList;
    } catch (error) {
      print('Error getting user story collections ${error.toString()}');
      rethrow;
    }
  }

  Future<void> createNewFeedCollection({
    required String? userId,
    required String? collectionName,
  }) async {
    try {
      if (collectionName != null && userId != null) {
        await _firestore
            .collection(Paths.users)
            .doc(userId)
            .collection(Paths.feedList)
            .doc(collectionName)
            .set({'date': DateTime.now().millisecondsSinceEpoch});
      }
    } catch (error) {
      print('Error in creating new collection ${error.toString()}');
      rethrow;
    }
  }
}
