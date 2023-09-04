import 'dart:convert';

import 'package:equatable/equatable.dart';

class TagUser extends Equatable {
  final String? userId;
  final String? username;

  const TagUser({
    this.userId,
    this.username,
  });

  TagUser copyWith({
    String? userId,
    String? username,
  }) {
    return TagUser(
      userId: userId ?? this.userId,
      username: username ?? this.username,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
    };
  }

  factory TagUser.fromMap(Map<String, dynamic> map) {
    return TagUser(
      userId: map['userId'],
      username: map['username'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TagUser.fromJson(String source) =>
      TagUser.fromMap(json.decode(source));

  @override
  String toString() => 'TagUser(userId: $userId, username: $username)';

  @override
  List<Object?> get props => [userId, username];
}
