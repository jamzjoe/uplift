import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_comment/data/comment_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_comment/data/user_comment_model.dart';
import 'package:uplift/utils/services/auth_services.dart';

class CommentRepository {
  final ref = FirebaseFirestore.instance.collection('Comments');
  Future addComment(String postID, String userID, String comment) async {
    final commentID = ref.doc().id;
    final commentModel = CommentModel(
            userId: userID,
            commentText: comment,
            commentId: commentID,
            postId: postID,
            createdAt: Timestamp.now())
        .toJson();
    log(commentModel.toString());
    await ref.doc(commentID).set(commentModel);
  }

  Future<List<UserCommentModel>> fetchComments(String postID) async {
    QuerySnapshot<Map<String, dynamic>> data =
        await ref.where("post_id", isEqualTo: postID).get();

    List<UserCommentModel> userCommentModel = [];
    List<CommentModel> comments =
        data.docs.map((e) => CommentModel.fromJson(e.data())).toList();
    for (var comment in comments) {
      final UserModel user =
          await AuthServices().getUserRecord(comment.userId!);
      userCommentModel.add(UserCommentModel(comment, user));
    }

    return userCommentModel;
  }

  Future<bool> deleteComment(CommentModel commentModel,
      String userIDofTheDeletor, String currentUserID) async {
    final commentUserID = commentModel.userId;
    final commentID = commentModel.commentId;
    if (commentUserID != currentUserID) {
      return false;
    } else {
      ref.doc(commentID).delete();
      return true;
    }
  }
}
