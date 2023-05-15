import 'package:cloud_firestore/cloud_firestore.dart';

class PrayerRequestPostModel {
  String? text;
  String? userId;
  Timestamp? date;
  Reactions? reactions;
  String? postId;
  List<String>? imageUrls; // Changed type to List<String>
  String? name;

  PrayerRequestPostModel({
    this.text,
    this.userId,
    this.date,
    this.reactions,
    this.postId,
    this.imageUrls, // Updated field name
    this.name,
  });

  PrayerRequestPostModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    userId = json['user_id'];
    date = json['date'];
    name = json['name'];
    reactions = json['reactions'] != null
        ? Reactions.fromJson(json['reactions'])
        : null;
    postId = json['post_id'];
    imageUrls = List<String>.from(json['image_url']); // Updated field name
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['user_id'] = userId;
    data['date'] = date;
    data['image_url'] = imageUrls; // Updated field name
    data['name'] = name;
    if (reactions != null) {
      data['reactions'] = reactions!.toJson();
    }
    data['post_id'] = postId;
    return data;
  }
}

class Reactions {
  List<Users>? users;

  Reactions({this.users});

  Reactions.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  String? userUid;

  Users({this.userUid});

  Users.fromJson(Map<String, dynamic> json) {
    userUid = json['user.uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user.uid'] = userUid;
    return data;
  }
}
