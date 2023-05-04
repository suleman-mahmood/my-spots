import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class User extends ChangeNotifier {
  String id;
  String accessToken;
  String fullName;
  String userName;
  String email;
  String phoneNumber;
  String profileText;
  List<double> location;
  String avatarUrl;
  int following;
  int followers;

  User({
    this.id = '',
    this.accessToken = '',
    this.fullName = '',
    this.userName = '',
    this.email = '',
    this.phoneNumber = '',
    this.profileText = '',
    this.location = const [0.0, 0.0],
    this.avatarUrl = '',
    this.following = 0,
    this.followers = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['full_name'],
      userName: json['user_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      profileText: json['profile_text'],
      location:
          List<double>.from(json['location'].map((value) => value.toDouble())),
      avatarUrl: json['avatar_url'],
      following: json['following'],
      followers: json['followers'],
    );
  }

  void updateUser(User user) {
    id = user.id;
    accessToken = user.accessToken;
    fullName = user.fullName;
    userName = user.userName;
    email = user.email;
    phoneNumber = user.phoneNumber;
    profileText = user.profileText;
    location = user.location;
    avatarUrl = user.avatarUrl;
    following = user.following;
    followers = user.followers;

    notifyListeners();
  }

  void setAccessToken(String token) {
    accessToken = token;

    notifyListeners();
  }
}

class Tag {
  String id;
  String tagName;

  Tag({this.id = '', this.tagName = ''});
}

class Reel extends ChangeNotifier {
  String id;
  String userId;
  String videoUrl;
  List<double> location;
  String caption;
  String description;
  String thumbnailUrl;
  bool banned;
  Set<Tag> tags;
  int likes;
  int views;
  int comments;
  int favourites;
  DateTime createdAt;

  Reel({
    this.id = '',
    this.userId = '',
    this.videoUrl = '',
    this.location = const [0.0, 0.0],
    this.caption = '',
    this.description = '',
    this.thumbnailUrl = '',
    this.banned = false,
    this.tags = const {},
    this.likes = 0,
    this.views = 0,
    this.comments = 0,
    this.favourites = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime(9999, 12, 31, 23, 59, 59, 999, 999);

  factory Reel.fromJson(Map<String, dynamic> json) {
    return Reel(
      id: json['id'],
      userId: json['user_id'],
      videoUrl: json['video_url'],
      location:
          List<double>.from(json['location'].map((value) => value.toDouble())),
      caption: json['caption'],
      description: json['description'],
      thumbnailUrl: json['thumbnail_url'],
      banned: json['banned'],
      tags: json['tags'],
      likes: json['likes'],
      views: json['views'],
      comments: json['comments'],
      favourites: json['favourites'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
