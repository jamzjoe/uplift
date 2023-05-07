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
      this.deviceToken});

  UserModel.fromJson(Map<String, dynamic> json) {
    displayName = json['display_name'] ?? 'Anonymous User';
    emailAddress = json['email_address'] ?? 'user@uplift.com';
    emailVerified = json['email_verified'] ?? false;
    userId = json['user_id'] ?? 'user_id';
    photoUrl = json['photo_url'] ?? 'photo_url';
    phoneNumber = json['phone_number'] ?? '+630000000000';
    createdAt = json['created_at'] ?? Timestamp.now();
    bio = json['bio'] ?? '';
    deviceToken = json['device_token'] ?? '';
    searchKey = json['search_key'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['display_name'] = displayName ?? 'Anonymous USer';
    data['email_address'] = emailAddress ?? 'user@uplift.com';
    data['email_verified'] = emailVerified ?? false;
    data['user_id'] = userId ?? 'user_id';
    data['photo_url'] = photoUrl ?? 'photo_url';
    data['phone_number'] = phoneNumber ?? '+630000000000';
    data['created_at'] = createdAt ?? Timestamp.now();
    data['bio'] = bio ?? '';
    data['device_token'] = deviceToken ?? '';
    data['search_key'] = searchKey ?? '';
    return data;
  }
}
