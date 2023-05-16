import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_comment/data/comment_model.dart';

class UserCommentModel {
  final CommentModel commentModel;
  final UserModel userModel;

  UserCommentModel(this.commentModel, this.userModel);
}
