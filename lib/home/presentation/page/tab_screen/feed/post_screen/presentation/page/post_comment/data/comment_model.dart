import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String? userId;
  String? commentText;
  String? commentId;
  String? postId;
  Timestamp? createdAt;

  CommentModel(
      {this.userId,
      this.commentText,
      this.commentId,
      this.createdAt,
      this.postId});

  CommentModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    commentText = json['comment_text'];
    commentId = json['comment_id'];
    postId = json['post_id'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['comment_text'] = commentText;
    data['comment_id'] = commentId;
    data['created_at'] = createdAt;
    data['post_id'] = postId;
    return data;
  }
}
