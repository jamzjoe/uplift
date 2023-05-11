import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';

class PostField extends StatelessWidget {
  const PostField({
    super.key,
    required this.userJoinModel,
  });

  final UserJoinedModel userJoinModel;

  @override
  Widget build(BuildContext context) {
    final UserModel userModel = userJoinModel.userModel;
    final User user = userJoinModel.user;
    return GestureDetector(
      onTap: () => enterPrayerField(context, userJoinModel),
      child: Container(
        color: whiteColor,
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Row(
          children: [
            ProfilePhoto(user: userModel, radius: 60),
            const SizedBox(width: 5),
            Expanded(
                child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                  color: const Color(0xffF6F6F6),
                  border: Border.all(color: secondaryColor.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(60)),
              child: const Text('What would you like us to pray for?',
                  style:
                      TextStyle(overflow: TextOverflow.ellipsis, fontSize: 16)),
            )),
            const SizedBox(width: 5),
            Icon(
              Ionicons.images,
              size: 25,
              color: secondaryColor.withOpacity(0.8),
            ),
          ],
        ),
      ),
    );
  }

  void enterPrayerField(BuildContext context, UserJoinedModel user) {
    context.pushNamed('post_field', extra: user);
  }
}
