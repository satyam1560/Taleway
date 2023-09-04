import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:viewstories/models/report.dart';
import 'package:viewstories/models/tag_user.dart';
import '/models/app_user.dart';
import '/models/views.dart';
import '/config/paths.dart';
import '/models/story.dart';
import '/repositories/story/base_story_repo.dart';

class StoryRepository extends BaseStoryRepository {
  final FirebaseFirestore _firestore;
  StoryRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createStory({
    required String userId,
    required Story story,
    required String collectionName,
  }) async {
    try {
      print('Story we are posting $story');
      final doc = await _firestore.collection(Paths.stories).add(story.toMap());
      final int tagUserLenght = story.taggedUser?.length ?? 0;
      for (int i = 0; i < tagUserLenght; i++) {
        print('Tag user user id ${story.taggedUser?[i]?.userId}}');
        _firestore
            .collection(Paths.stories)
            .doc(doc.id)
            .collection('taggedUsers')
            .doc(story.taggedUser?[i]?.userId)
            .set({});
      }

      final docRef = await _firestore
          .collection(Paths.users)
          .doc(userId)
          .collection('stories-list')
          .doc(collectionName)
          .get();

      if (!docRef.exists) {
        _firestore
            .collection(Paths.users)
            .doc(userId)
            .collection('stories-list')
            .doc(collectionName)
            .set({'date': DateTime.now().millisecondsSinceEpoch});
      }

      print('Doc ref -------- $docRef');

      print('Doc ref ------ ${docRef.id}');

      //  await docRef.set({'date': DateTime.now().millisecondsSinceEpoch});

      // docRef.set({});

      // if (docRef.id == collectionName) {
      //   await docRef.set({'date': DateTime.now().millisecondsSinceEpoch});
      // } else {
      //   print('antohter doc ref rns');
      //   await docRef.set({});
      // }
    } catch (error) {
      print('Error in create post ${error.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<Future<Story?>>> getUserTodayStories({
    required String? userId,
  }) async {
    try {
      final authorRef =
          FirebaseFirestore.instance.collection(Paths.users).doc(userId);
      final storiesSnaps = await _firestore
          .collection(Paths.stories)
          .where('author', isEqualTo: authorRef)
          .where('expireAt', isGreaterThan: Timestamp.fromDate(DateTime.now()))
          .get();

      return storiesSnaps.docs.map((snap) => Story.fromDocument(snap)).toList();
    } catch (error) {
      print('Error getting user todays story ${error.toString()}');
      rethrow;
    }
  }

  Stream<List<Future<Story?>>> streamUserStories({
    required String? userId,
    required String collectionName,
  }) {
    try {
      // final authorRef = _firestore.collection(Paths.users).doc(userId);

      print('Collection name ---- $collectionName');
      print('User id ------ $userId');
      final authorDoc =
          FirebaseFirestore.instance.collection(Paths.users).doc(userId);
      return _firestore
          .collection(Paths.stories)
          .where('author', isEqualTo: authorDoc)
          //  .doc(userId)
          // .collection(Paths.userStories)
          .where('collectionName', isEqualTo: collectionName)

          // .collection(collectionName)
          .orderBy('date', descending: true)

          //
          //.where('author', isEqualTo: authorRef)
          //.orderBy('data', descending: true);
          .snapshots()
          .map((snap) =>
              snap.docs.map((doc) => Story.fromDocument(doc)).toList());
    } catch (error) {
      print('Error getting users stories ${error.toString()}');
      rethrow;
    }
  }

  Future<List<AppUser?>> getTaggedUsers(
      {required List<TagUser?> taggUsers}) async {
    try {
      List<AppUser?> users = [];
      for (int i = 0; i < taggUsers.length; i++) {
        print('Tag user id --- ${taggUsers[i]}');

        final userSnap = await _firestore
            .collection(Paths.users)
            .doc(taggUsers[i]?.userId)
            .get();
        users.add(AppUser.fromDocument(userSnap));
      }
      return users;
    } catch (error) {
      print('Error getting tagged users ${error.toString()}');
      rethrow;
    }
  }

  Future<List<AppUser?>> taggedUsers({
    required String? storyId,
    required List<TagUser?> tagUsers,
  }) async {
    try {
      List<AppUser?> users = [];
      for (var element in tagUsers) {
        // final userSnap = await _firestore
        //     .collection(Paths.stories)
        //     .doc(storyId)
        //     .collection('taggedUsers')
        //     .doc(element)
        //     .get();
        print('Tagged user -------$element');
        final userSnap =
            await _firestore.collection(Paths.users).doc(element?.userId).get();

        print('tag user snap --- ${userSnap.id}');
        users.add(AppUser.fromDocument(userSnap));
      }
      print('Tagged Usrs ----- $users');
      return users;
    } catch (error) {
      print('Error getting taggedUsrs ${error.toString()}');
      rethrow;
    }
  }

  Future<int?> getStoryCount({required String? storyId}) async {
    try {
      final snaps = await _firestore
          .collection(Paths.views)
          .doc(storyId)
          .collection(Paths.storyViews)
          .get();

      print('Lenght ---- ${snaps.docs.length}');
      return snaps.docs.length;
    } catch (error) {
      print('Error getting story count ${error.toString()}');
      rethrow;
    }
  }

  Future<Views?> getStoriesViews({required String? storyId}) async {
    try {
      print('Story id for repo -- $storyId');
      List<AppUser?> viewers = [];
      final snaps = await _firestore
          .collection(Paths.views)
          .doc(storyId)
          .collection(Paths.storyViews)
          .get();

      final count = snaps.docs.length;

      for (var element in snaps.docs) {
        final userSnap =
            await _firestore.collection(Paths.users).doc(element.id).get();
        final user = AppUser.fromDocument(userSnap);
        viewers.add(user);
      }

      return Views(viewers: viewers, viewsCount: count);
    } catch (error) {
      print('Error getting story count ${error.toString()}');
      rethrow;
    }
  }

  Future<void> addStoryView({
    required String? userId,
    required String? storyId,
  }) async {
    try {
      final doc = _firestore
          .collection(Paths.views)
          .doc(storyId)
          .collection(Paths.storyViews)
          .doc(userId);

      final snap = await doc.get();

      if (!snap.exists) {
        print('User doc do not exits}');
        doc.set({});
      }
    } catch (error) {
      print('Error adding story view ${error.toString()}');
      rethrow;
    }
  }

  Future<List<Future<Story?>>> getUserStories({required String? userId}) async {
    try {
      final authorRef = _firestore.collection(Paths.users).doc(userId);

      print('Author ref from user stories -- $authorRef');
      final storySnaps = await _firestore
          .collection(Paths.stories)
          .where('author', isEqualTo: authorRef)
          .get();

      return storySnaps.docs.map((doc) => Story.fromDocument(doc)).toList();
    } catch (error) {
      print('Error in getting user stories ${error.toString()}');
      rethrow;
    }
  }

  Future<void> reportPost({
    required String? userId,
    required String? postId,
    required Report? report,
  }) async {
    if (userId == null || postId == null || report == null) {
      return;
    }

    await _firestore.collection(Paths.reportedPosts).doc(postId).set(
      {
        'reportedUser': _firestore.collection(Paths.users).doc(userId),
        'report': report.toMap()
      },
    );
  }
}
