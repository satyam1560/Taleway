import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/notif.dart';

import '/config/paths.dart';
import '/models/app_user.dart';
import '/repositories/user/base_user_repo.dart';
import '/utils/image_util.dart';

class UserRepository extends BaseUserRepository {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<void> editUserProfile({
    required String? name,
    required String? bio,
    required Uint8List? imageFile,
    required String? userId,
  }) async {
    try {
      if (userId != null && imageFile != null) {
        final doc = await _firestore.collection(Paths.users).doc(userId).get();

        print('Checking doc exists or not --------- ${doc.exists}');

        if (doc.exists) {
          final user = AppUser.fromMap(doc.data()!);

          final String? downloadUrl =
              await ImageUtil.uploadProfileImageToStorage(
                  'profileImages', imageFile, false, userId);
          await _firestore.collection(Paths.users).doc(userId).set(user
              .copyWith(
                name: name,
                profilePic: downloadUrl,
                bio: bio,
              )
              .toMap());
        }
      }
    } catch (error) {
      print('Error in edit profile ${error.toString()}');
      rethrow;
    }
  }

  @override
  Stream<List<AppUser?>> searchUser(String username) {
    try {
      return _firestore
          .collection(Paths.users)
          .where('username', isGreaterThanOrEqualTo: username)
          // .where('username', isGreaterThanOrEqualTo: username)
          .withConverter<AppUser>(
              fromFirestore: (snapshot, _) => AppUser.fromMap(snapshot.data()!),
              toFirestore: (user, _) => user.toMap())
          .snapshots()
          .map((users) {
        return users.docs.map((doc) => doc.data()).toList();
      });
    } catch (error) {
      print('Error getting user ${error.toString()}');
      // throw const Failure(message: 'Error searching todos !');
      rethrow;
    }
  }

  Stream<AppUser?> streamUserProfile({required String? userId}) {
    try {
      final userSnaps = _firestore
          .collection(Paths.users)
          .doc(userId)
          .withConverter<AppUser>(
              fromFirestore: (snapshot, _) => AppUser.fromMap(snapshot.data()!),
              toFirestore: (user, _) => user.toMap())
          .snapshots();
      return userSnaps.map((event) => event.data());
    } catch (error) {
      print('Error in stream user profile');
      rethrow;
    }
  }

  @override
  Future<AppUser?> getUserProfile({required String? userId}) async {
    try {
      final userSnap = await _firestore
          .collection(Paths.users)
          .doc(userId)
          .withConverter<AppUser>(
              fromFirestore: (snapshot, _) => AppUser.fromMap(snapshot.data()!),
              toFirestore: (user, _) => user.toMap())
          .get();

      return userSnap.data();
    } catch (error) {
      print('Error getting user ${error.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<String?>> getUserStoryCollection({
    required String? userID,
    required String? collectionName,
  }) async {
    try {
      if (collectionName == null) {
        return [];
      }
      print('Usr id ----- $userID');
      final snapshot = await _firestore
          .collection(Paths.users)
          .doc(userID)
          .collection(collectionName)
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

  Stream<List<String?>> streamUserStoryCollection({
    required String? userID,
    required String collectionName,
  }) {
    try {
      final snapshot = _firestore
          .collection(Paths.users)
          .doc(userID)
          .collection(collectionName)
          .snapshots();

      // for (var element in snapshot.docs) {
      //   storiesList.add(element.id);
      // }
      return snapshot.map((querySnap) {
        return querySnap.docs.map((doc) {
          print('Id------------ ${doc.id}');
          return doc.id;
        }).toList();

        // doc.id).toList();
      });

      // .map((doc) => doc.id).toList();
      // return storiesList;
    } catch (error) {
      print('Error getting user story collections ${error.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> followUser({
    required String? userId,
    required String? followUserId,
  }) async {
    try {
      // Add followUser to user's userFollowing.
      await _firestore
          .collection(Paths.following)
          .doc(userId)
          .collection(Paths.userFollowing)
          .doc(followUserId)
          .set({});
      // Add user to followUser's userFollowers.
      await _firestore
          .collection(Paths.followers)
          .doc(followUserId)
          .collection(Paths.userFollowers)
          .doc(userId)
          .set({});

      final notification = Notif(
        type: NotifType.follow,
        fromUser: AppUser.empty.copyWith(uid: userId),
        date: DateTime.now(),
      );

      await _firestore
          .collection(Paths.notifications)
          .doc(followUserId)
          .collection(Paths.userNotifications)
          .add(notification.toDocument());

      // await _firestore
      //     .collection(Paths.followers)
      //     .doc(followUserId)
      //     .collection(Paths.userFollowers)
      //     .doc(userId)
      //     .set({});

      // await _firestore
      //     .collection(Paths.following)
      //     .doc(userId)
      //     .collection(Paths.userFollowing)
      //     .doc(followUserId)
      //     .set({});

      // final notification = Notif(
      //   type: NotifType.follow,
      //   fromUser: AppUser.empty.copyWith(uid: userId),
      //   date: DateTime.now(),
      // );

      // _firestore
      //     .collection(Paths.notifications)
      //     .doc(followUserId)
      //     .collection(Paths.userNotifications)
      //     .add(notification.toDocument());
    } catch (error) {
      print('Error in follow user ${error.toString()}');
      rethrow;
    }
  }

  Future<void> unFollowUser({
    required String? userId,
    required String? unfollowUserId,
  }) async {
    try {
      // Remove unfollowUser from user's userFollowing.
      await _firestore
          .collection(Paths.following)
          .doc(userId)
          .collection(Paths.userFollowing)
          .doc(unfollowUserId)
          .delete();
      // Remove user from unfollowUser's userFollowers.
      await _firestore
          .collection(Paths.followers)
          .doc(unfollowUserId)
          .collection(Paths.userFollowers)
          .doc(userId)
          .delete();

      // await _firestore
      //     .collection(Paths.followers)
      //     .doc(unfollowUserId)
      //     .collection(Paths.userFollowers)
      //     .doc(userId)
      //     .delete();

      // await _firestore
      //     .collection(Paths.following)
      //     .doc(userId)
      //     .collection(Paths.userFollowing)
      //     .doc(unfollowUserId)
      //     .delete();

      // deleting user from feed
      await _firestore
          .collection(Paths.feed)
          .doc(userId)
          .collection(Paths.users)
          .doc(unfollowUserId)
          .delete();
    } catch (error) {
      print('Error in follow user ${error.toString()}');
      rethrow;
    }
  }

  @override
  Future<bool> checkAlreadyFollowing({
    required String? currentUserId,
    required String? followUserId,
  }) async {
    try {
      final docSnap = await _firestore
          .collection(Paths.following)
          .doc(currentUserId)
          .collection(Paths.userFollowing)
          .doc(followUserId)
          .get();

      return docSnap.exists;
    } catch (error) {
      print('Errog in check already following  ${error.toString()}');
      rethrow;
    }
  }

  Future<void> addUseToFeed({
    required String? currentUserId,
    required String? otherUserId,
    required String? collectionName,
  }) async {
    try {
      if (currentUserId == null ||
          otherUserId == null ||
          collectionName == null) return;

      await _firestore
          .collection(Paths.feed)
          .doc(currentUserId)
          .collection(Paths.users)
          .doc(otherUserId)
          .set({'collectionName': collectionName});

      await _firestore
          .collection(Paths.users)
          .doc(currentUserId)
          .collection(Paths.feedList)
          .doc(collectionName)
          .set({'date': DateTime.now().millisecondsSinceEpoch});

      // await _firestore
      //     .collection(Paths.feed)
      //     .doc(currentUserId)
      //     .collection(collectionName)
      //     .doc(otherUserId)
      //     .set({});
    } catch (error) {
      print('Error in adding user to feed ${error.toString()}');
    }
  }

  Future<void> createNewProfileCollection({
    required String? userId,
    required String? collectionName,
  }) async {
    try {
      if (collectionName != null && userId != null) {
        await _firestore
            .collection(Paths.users)
            .doc(userId)
            .collection(Paths.storiesList)
            .doc(collectionName)
            .set({'date': DateTime.now().millisecondsSinceEpoch});
      }
    } catch (error) {
      print('Error in creating new collection ${error.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<AppUser?>> getFollowingUsers({
    required String? userId,
  }) async {
    print('provided usrs id$userId');
    List<AppUser?> users = [];
    try {
      final followingQuery = await _firestore
          .collection(Paths.following)
          .doc(userId)
          .collection(Paths.userFollowing)
          .get();

      for (var i = 0; i < followingQuery.docs.length; i++) {
        final uid = followingQuery.docs[i].id;

        print('User isds -------------- $uid');
        final userSnap =
            await _firestore.collection(Paths.users).doc(uid).get();
        users.add(AppUser.fromDocument(userSnap));
      }
      return users;
    } catch (error) {
      print('Error getting followed users ${error.toString()}');
      rethrow;
    }
  }

  Future<List<AppUser?>> getNewUsers({String? lastUserId}) async {
    try {
      DateTime.now().compareTo(DateTime.now());

      final today = DateTime.now();

      final before10 = today.subtract(const Duration(days: 10));

      print('Before date ${Timestamp.fromDate(before10)}');

      QuerySnapshot<AppUser?> userSnaps;

      if (lastUserId == null) {
        userSnaps = await _firestore
            .collection(Paths.users)
            .withConverter<AppUser>(
                fromFirestore: (snapshot, _) => AppUser.fromDocument(snapshot),
                toFirestore: (snapshot, _) => snapshot.toMap())
            .where('createdAt',
                isGreaterThanOrEqualTo: Timestamp.fromDate(before10))
            .limit(3)
            .get();

        print('Recent snaps --- $userSnaps');
      } else {
        final lastUserDoc = await _firestore
            .collection(Paths.users)
            .withConverter<AppUser>(
                fromFirestore: (snapshot, _) => AppUser.fromDocument(snapshot),
                toFirestore: (snapshot, _) => snapshot.toMap())
            .doc(lastUserId)
            .get();

        if (!lastUserDoc.exists) {
          return [];
        }

        userSnaps = await _firestore
            .collection(Paths.users)
            .withConverter<AppUser>(
                fromFirestore: (snapshot, _) => AppUser.fromDocument(snapshot),
                toFirestore: (snapshot, _) => snapshot.toMap())
            .startAfterDocument(lastUserDoc)
            .where('createdAt',
                isGreaterThanOrEqualTo: Timestamp.fromDate(before10))
            .limit(3)
            .get();
      }

      // final userSnap = await _firestore
      //     .collection(Paths.users)
      //     .withConverter<AppUser>(
      //         fromFirestore: (snapshot, _) => AppUser.fromDocument(snapshot),
      //         toFirestore: (snapshot, _) => snapshot.toMap())
      //     .where('createdAt',
      //         isGreaterThanOrEqualTo: Timestamp.fromDate(before10))
      //     .limit(3)
      //     .get();

      print('Recent snaps --- $userSnaps');

      return userSnaps.docs.map((doc) => doc.data()).toList();
    } catch (error) {
      print('Error getting new users ${error.toString()}');
      rethrow;
    }
  }

  Future<List<AppUser?>> getRecentUsers() async {
    try {
      DateTime.now().compareTo(DateTime.now());

      final createAt = DateTime(2022, 2, 20);

      final today = DateTime.now();

      final before10 = today.subtract(const Duration(days: 60));

      print('Before date ${Timestamp.fromDate(before10)}');

      //   final today = DateTime.now();

      final after10 = createAt.add(const Duration(days: 10));

      // today.isAfter(createAt);

      print('After 10 days ------ $after10');

      print('Checkking ------------- ${createAt.isAfter(before10)}');

      // print('find data ---------- ${today.compareTo(createAt)}');

      final userSnaps = await _firestore
          .collection(Paths.users)
          .withConverter<AppUser>(
              fromFirestore: (snapshot, _) => AppUser.fromDocument(snapshot),
              toFirestore: (snapshot, _) => snapshot.toMap())
          .where('createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(before10))

          // get only 10 days old user
          // .orderBy('createAt', descending: true)
          //  .where('createAt', isGreaterThan: DateTime.now())
          .get();

      return userSnaps.docs.map((doc) => doc.data()).toList();
    } catch (error) {
      print('Error getting new users ${error.toString()}');
      rethrow;
    }
  }

  Future delelteProfileStoryCollection({
    required String? userId,
    required String? collectionName,
  }) async {
    try {
      await _firestore
          .collection(Paths.users)
          .doc(userId)
          .collection(Paths.storiesList)
          .doc(collectionName)
          .delete();
    } catch (error) {
      print('Error in deleting profile story collection ${error.toString()}');
    }
  }

  Future<void> blockUser({
    required String? currentUserId,
    required String? otherUserId,
  }) async {
    try {
      if (currentUserId == null || otherUserId == null) {
        return;
      }
      await _firestore
          .collection(Paths.blocked)
          .doc(currentUserId)
          .collection(Paths.blockedUsers)
          .doc(otherUserId)
          .set({});
    } catch (error) {
      print('Error in blocking user ${error.toString()}');
    }
  }

  Future<bool> checkBlocked({
    required String? currentUserId,
    required String? otherUserId,
  }) async {
    try {
      final userSnap = await _firestore
          .collection(Paths.blocked)
          .doc(currentUserId)
          .collection(Paths.blockedUsers)
          .doc(otherUserId)
          .get();

      return userSnap.exists;
    } catch (error) {
      print('Error checking already blocked ${error.toString()}');
      rethrow;
    }
  }

  Future<void> unBlockUser({
    required String? currentUserId,
    required String? otherUserId,
  }) async {
    try {
      await _firestore
          .collection(Paths.blocked)
          .doc(currentUserId)
          .collection(Paths.blockedUsers)
          .doc(otherUserId)
          .delete();

//return userSnap.exists;
    } catch (error) {
      print('Error unblocking user ${error.toString()}');
      rethrow;
    }
  }
}
