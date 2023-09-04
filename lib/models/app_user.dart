import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String? username;
  final String? email;
  final String? name;
  final String? uid;
  final String? profilePic;
  final String? bio;
  final List<String?> collectionName;
  final int? followers;
  final int? following;
  final DateTime? createdAt;

  const AppUser({
    this.username,
    this.email,
    this.name,
    this.uid,
    this.profilePic,
    this.bio,
    this.collectionName = const [],
    this.followers = 0,
    this.following = 0,
    this.createdAt,
  });

  AppUser copyWith({
    String? username,
    String? email,
    String? name,
    String? uid,
    String? profilePic,
    String? bio,
    List<String?>? collectionName,
    int? followers,
    int? following,
    DateTime? createdAt,
  }) {
    return AppUser(
      username: username ?? this.username,
      email: email ?? this.email,
      name: name ?? this.name,
      uid: uid ?? this.uid,
      profilePic: profilePic ?? this.profilePic,
      bio: bio ?? this.bio,
      collectionName: collectionName ?? this.collectionName,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'name': name,
      'uid': uid,
      'profilePic': profilePic,
      'bio': bio,
      'following': following,
      'followers': followers,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      username: map['username'],
      email: map['email'],
      name: map['name'],
      uid: map['uid'],
      profilePic: map['profilePic'],
      bio: map['bio'],
      followers: (map['followers'] ?? 0).toInt(),
      following: (map['following'] ?? 0).toInt(),
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  static const empty = AppUser(
    username: '',
    email: '',
    name: '',
    uid: '',
    profilePic: '',
    bio: '',
    followers: 0,
    following: 0,
    createdAt: null,
  );

  factory AppUser.fromDocument(DocumentSnapshot? doc) {
    // if (doc == null) return null;
    final data = doc?.data() as Map?;
    print('App users ---- $data');
    return AppUser(
      username: data?['username'],
      email: data?['email'],
      name: data?['name'],
      uid: data?['uid'],
      profilePic: data?['profilePic'],
      bio: data?['bio'],
      followers: (data?['followers'] ?? 0).toInt(),
      following: (data?['following'] ?? 0).toInt(),
      createdAt: data?['createdAt'] != null
          ? (data?['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  static const emptyUser = AppUser(
    uid: '',
    name: '',
    username: '',
    profilePic: '',
    email: '',
    bio: '',
    followers: 0,
    following: 0,
    createdAt: null,
  );

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppUser(username: $username, email: $email, name: $name, uid: $uid, followers: $followers, following: $following, profilePic: $profilePic, createdAt: $createdAt)';
  }

  @override
  List<Object?> get props => [
        username,
        email,
        name,
        uid,
        profilePic,
        followers,
        following,
        createdAt,
      ];
}
