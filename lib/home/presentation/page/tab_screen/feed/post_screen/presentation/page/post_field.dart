import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/constant/constant.dart';
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
    return GestureDetector(
      onTap: () => enterPrayerField(context, widget.userJoinModel),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: const Color(0xffF6F6F6),
            border:
                Border.all(color: secondaryColor.withOpacity(0.2), width: 0.5),
            borderRadius: BorderRadius.circular(15)),
        child: SmallText(
            text: "What would you like us to pray for?", color: lighter),
      ),
    );
  }

  void enterPrayerField(BuildContext context, UserJoinedModel user) {
    context.pushNamed('post_field', extra: user);
  }
}
