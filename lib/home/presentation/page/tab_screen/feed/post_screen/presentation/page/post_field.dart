import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
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
    return Row(
      children: [
        ProfilePhoto(user: userModel, radius: 10),
        const SizedBox(width: 10),
        Expanded(
            child: GestureDetector(
          onTap: () => enterPrayerField(context, widget.userJoinModel),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            decoration: BoxDecoration(
                color: const Color(0xffF6F6F6),
                border: Border.all(
                    color: secondaryColor.withOpacity(0.2), width: 0.5),
                borderRadius: BorderRadius.circular(15)),
            child: SmallText(text: "Share anything you want.", color: lighter),
          ),
        )),
        const SizedBox(width: 5),
      ],
    );
  }

  void enterPrayerField(BuildContext context, UserJoinedModel user) {
    context.pushNamed('post_field', extra: user);
  }
}
