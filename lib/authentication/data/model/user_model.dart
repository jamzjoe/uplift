import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? displayName;
  String? emailAddress;
  bool? emailVerified;
  String? userId;
  String? photoUrl;
  String? phoneNumber;
  Timestamp? createdAt;
  String? bio;
  String? searchKey;
  String? deviceToken;
  String? provider;
  String? privacy;

  UserModel(
      {this.displayName,
      this.emailAddress,
      this.emailVerified,
      this.userId,
      this.photoUrl,
      this.phoneNumber,
      this.createdAt,
      this.bio,
      this.searchKey,
      this.deviceToken,
      this.provider,
      this.privacy});

  UserModel.fromJson(Map<String, dynamic> json) {
    displayName = json['display_name'];
    emailAddress = json['email_address'];
    emailVerified = json['email_verified'];
    userId = json['user_id'];
    photoUrl = json['photo_url'];
    phoneNumber = json['phone_number'];
    createdAt = json['created_at'];
    bio = json['bio'];
    deviceToken = json['device_token'];
    searchKey = json['search_key'];
    provider = json['provider'];
    privacy = json['privacy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['display_name'] = displayName;
    data['email_address'] = emailAddress;
    data['email_verified'] = emailVerified;
    data['user_id'] = userId;
    data['photo_url'] = photoUrl;
    data['phone_number'] = phoneNumber;
    data['created_at'] = createdAt;
    data['bio'] = bio;
    data['device_token'] = deviceToken;
    data['search_key'] = searchKey;
    data['provider'] = provider;
    data['privacy'] = privacy;
    return data;
  }
}
