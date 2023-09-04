abstract class BaseFeedRepository {
  Future<void> deleteUserFeedCollectin({
    required String? userId,
    required String? collectionName,
  });
}
