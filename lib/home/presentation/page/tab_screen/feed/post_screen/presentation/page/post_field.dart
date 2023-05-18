import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_form/post_form_screen.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class PostField extends StatefulWidget {
  const PostField({
    super.key,
    required this.userJoinModel,
  });

  final UserJoinedModel userJoinModel;

  @override
  State<PostField> createState() => _PostFieldState();
}

class _PostFieldState extends State<PostField> {
  @override
  Widget build(BuildContext context) {
    final UserModel userModel = widget.userJoinModel.userModel;
    final User user = widget.userJoinModel.user;
    return Container(
      color: whiteColor,
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        children: [
          ProfilePhoto(user: userModel, radius: 60),
          const SizedBox(width: 5),
          Expanded(
              child: GestureDetector(
            onTap: () => enterPrayerField(context, widget.userJoinModel),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                  color: const Color(0xffF6F6F6),
                  border: Border.all(
                      color: secondaryColor.withOpacity(0.2), width: 0.5),
                  borderRadius: BorderRadius.circular(60)),
              child: const SmallText(
                  text: "What would you like us to pray for?",
                  color: secondaryColor),
            ),
          )),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return PostFormScreen(
                  user: widget.userJoinModel,
                  isPickImage: true,
                );
              },
            )),
            child: Icon(
              Ionicons.images,
              size: 25,
              color: secondaryColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  void enterPrayerField(BuildContext context, UserJoinedModel user) {
    context.pushNamed('post_field', extra: user);
  }
}
