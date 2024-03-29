import 'package:cloud_firestore/cloud_firestore.dart';

enum PostPrivacy { public, private }

class PrayerRequestPostModel {
  String? text;
  String? userId;
  Timestamp? date;
  Reactions? reactions;
  String? postId;
  String? name;
  String? privacy;
  String? title;

  PrayerRequestPostModel(
      {this.text,
      this.userId,
      this.date,
      this.reactions,
      this.postId,
      this.name,
      this.title});

  PrayerRequestPostModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    userId = json['user_id'];
    date = json['date'];
    name = json['custom_name'];
    title = json['title'];
    reactions = json['reactions'] != null
        ? Reactions.fromJson(json['reactions'])
        : null;
    postId = json['post_id'];
    privacy = json['privacy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['user_id'] = userId;
    data['date'] = date;
    data['custom_name'] = name;
    data['title'] = title;
    if (reactions != null) {
      data['reactions'] = reactions!.toJson();
    }
    data['post_id'] = postId;
    data['privacy'] = privacy;
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
