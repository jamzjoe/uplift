import 'package:flutter/material.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_comment/presentation/comment_view.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/just_now.dart';
import 'package:uplift/utils/widgets/pop_up.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';
import 'package:uplift/utils/widgets/small_text.dart';

import '../data/user_comment_model.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({
    super.key,
    required this.encourages,
    required this.index,
    required this.currentUser, this.encourager,
  });

  final List<UserCommentModel> encourages;
  final int index;
  final UserModel? currentUser;
  final UserModel? encourager;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CustomDialog()
            .showProfile(context, currentUser!, encourager!);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfilePhoto(user: encourages[index].userModel),
            const SizedBox(width: 15),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      HeaderText(
                          text: encourages[index].userModel.displayName!,
                          color: darkColor,
                          size: 16),
                      SmallText(
                          textAlign: TextAlign.start,
                          text: DateFeature().formatDateTime(encourages[index]
                              .commentModel
                              .createdAt!
                              .toDate()),
                          color: lightColor)
                    ],
                  ),
                  SmallText(
                      text: encourages[index].commentModel.commentText!,
                      color: lighter),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
