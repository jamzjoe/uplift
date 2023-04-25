import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/default_text.dart';

class PostField extends StatelessWidget {
  const PostField({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => enterPrayerField(context, user),
      child: Container(
        margin: const EdgeInsets.only(top: 5, bottom: 0),
        color: whiteColor,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoURL!),
            ),
            const SizedBox(width: 5),
            Expanded(
                child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                  color: const Color(0xffF6F6F6),
                  border: Border.all(color: secondaryColor.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(60)),
              child: const DefaultText(
                  text: 'What would you like us to pray for?',
                  color: secondaryColor),
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

  void enterPrayerField(BuildContext context, User user) {
    context.pushNamed('post_field', extra: user);
  }
}
