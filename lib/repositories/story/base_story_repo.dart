import 'package:viewstories/models/story.dart';

abstract class BaseStoryRepository {
  Future<void> createStory({
    required String userId,
    required Story story,
    required String collectionName,
  });

  Future<List<Future<Story?>>> getUserTodayStories({
    required String? userId,
  });
}
