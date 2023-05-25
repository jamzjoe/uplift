import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/friends_feed.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class FriendItem extends StatelessWidget {
  const FriendItem({
    super.key,
    required this.userFriendship,
    required this.currentUser,
  });
  final UserModel userFriendship;
  final UserModel currentUser;

  @override
  Widget build(BuildContext context) {
    UserModel user = userFriendship;
    return GestureDetector(
      onTap: () {
        if (context.canPop()) {
          context.pop();
        }
        showFlexibleBottomSheet(
          minHeight: 0,
          initHeight: 0.92,
          maxHeight: 1,
          isSafeArea: true,
          context: context,
          builder: (context, scrollController, bottomSheetOffset) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [], // Remove the shadow by using an empty list of BoxShadow
              ),
              child: FriendsFeed(
                userModel: user,
                currentUser: currentUser,
                scrollController: scrollController,
              ),
            );
          },
          anchors: [0, 0.5, 1],
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            ProfilePhoto(user: user, radius: 15),
            const SizedBox(width: 15),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeaderText(
                              text: user.displayName ?? 'User',
                              color: darkColor,
                              size: 18,
                            ),
                            const SizedBox(height: 5),
                            SmallText(
                                text:
                                    'Friends since ${user.createdAt!.toDate().year}',
                                color: lightColor),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
