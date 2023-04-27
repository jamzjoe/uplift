class UserModel {
  String? displayName;
  String? emailAddress;
  bool? emailVerified;
  String? userId;
  String? photoUrl;
  String? phoneNumber;
  DateTime? createdAt;
  String? bio;

  UserModel(
      {this.displayName,
      this.emailAddress,
      this.emailVerified,
      this.userId,
      this.photoUrl,
      this.phoneNumber,
      this.createdAt,
      this.bio});

  UserModel.fromJson(Map<String, dynamic> json) {
    displayName = json['display_name'];
    emailAddress = json['email_address'];
    emailVerified = json['email_verified'];
    userId = json['user_id'];
    photoUrl = json['photo_url'];
    phoneNumber = json['phone_number'];
    createdAt = json['created_at'];
    bio = json['bio'];
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
    return data;
  }
}
