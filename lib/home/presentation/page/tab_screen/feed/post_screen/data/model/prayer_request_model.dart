import 'package:cloud_firestore/cloud_firestore.dart';

class PrayerRequestPostModel {
  String? text;
  String? userId;
  Timestamp? date;
  Reactions? reactions;
  String? postID;

  PrayerRequestPostModel({this.text, this.userId, this.date, this.reactions});

  PrayerRequestPostModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    userId = json['user_id'];
    date = json['date'];
    postID = json['post_id'];
    reactions = json['reactions'] != null
        ? Reactions.fromJson(json['reactions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['user_id'] = userId;
    data['date'] = date;
    data['post_id'] = postID;
    if (reactions != null) {
      data['reactions'] = reactions!.toJson();
    }
    return data;
  }
}

class Reactions {
  Users? users;

  Reactions({this.users});

  Reactions.fromJson(Map<String, dynamic> json) {
    users = json['users'] != null ? Users.fromJson(json['users']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (users != null) {
      data['users'] = users!.toJson();
    }
    return data;
  }
}

class Users {
  bool? user;

  Users({this.user});

  Users.fromJson(Map<String, dynamic> json) {
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    return data;
  }
}
