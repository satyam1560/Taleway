import 'dart:typed_data';

import '/models/app_user.dart';

abstract class BaseUserRepository {
  Future<void> editUserProfile({
    required String? name,
    required String? bio,
    required Uint8List? imageFile,
    required String? userId,
  });

  Stream<List<AppUser?>> searchUser(String username);
  Future<AppUser?> getUserProfile({required String? userId});
  Future<List<String?>> getUserStoryCollection({
    required String? userID,
    required String collectionName,
  });
  Future<void> followUser({
    required String? userId,
    required String? followUserId,
  });
  Future<bool> checkAlreadyFollowing({
    required String? currentUserId,
    required String? followUserId,
  });
  Future<List<AppUser?>> getFollowingUsers({
    required String? userId,
  });
}
