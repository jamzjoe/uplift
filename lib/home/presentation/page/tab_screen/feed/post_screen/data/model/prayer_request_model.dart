import 'package:cloud_firestore/cloud_firestore.dart';

class PrayerRequestPostModel {
  String? text;
  String? userId;
  Timestamp? date;
  Reactions? reactions;
  String? postId;

  PrayerRequestPostModel(
      {this.text, this.userId, this.date, this.reactions, this.postId});

  PrayerRequestPostModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    userId = json['user_id'];
    date = json['date'];
    reactions = json['reactions'] != null
        ? Reactions.fromJson(json['reactions'])
        : null;
    postId = json['post_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['user_id'] = userId;
    data['date'] = date;
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
