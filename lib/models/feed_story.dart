import 'dart:convert';

import 'package:equatable/equatable.dart';

import '/models/app_user.dart';
import '/models/story.dart';

class FeedStory extends Equatable {
  final AppUser? user;
  final Story? story;

  const FeedStory({
    this.user,
    this.story,
  });

  FeedStory copyWith({
    AppUser? user,
    Story? story,
  }) {
    return FeedStory(
      user: user ?? this.user,
      story: story ?? this.story,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user?.toMap(),
      'story': story?.toMap(),
    };
  }

  factory FeedStory.fromMap(Map<String, dynamic> map) {
    return FeedStory(
      user: map['user'] != null ? AppUser.fromMap(map['user']) : null,
      // story: map['story'] != null ? Story.fromMap(map['story']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FeedStory.fromJson(String source) =>
      FeedStory.fromMap(json.decode(source));

  @override
  String toString() => 'FeedStory(user: $user, story: $story)';

  @override
  List<Object?> get props => [user, story];
}
