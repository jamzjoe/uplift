import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

import '../../../constant/constant.dart';
import '../../../utils/widgets/header_text.dart';

class PostFormScreen extends StatefulWidget {
  const PostFormScreen({super.key, required this.user});
  final User user;

  @override
  State<PostFormScreen> createState() => _PostFormScreenState();
}

class _PostFormScreenState extends State<PostFormScreen> {
  @override
  Widget build(BuildContext context) {
    final User user = widget.user;
    return Scaffold(
      appBar: AppBar(
        title: const HeaderText(text: 'Create post', color: secondaryColor),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: CustomButton(
                widget: DefaultText(text: 'Post', color: whiteColor),
                color: primaryColor),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(user.photoURL!),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderText(
                      text: user.displayName!,
                      color: secondaryColor,
                      size: 18,
                    ),
                    Row(
                      children: const [
                        SmallText(text: 'Post to', color: lightColor),
                        SmallText(text: ' Public', color: primaryColor),
                      ],
                    ),
                  ],
                )
              ],
            ),
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                    hintStyle:
                        TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
                    hintText: 'Write something you want to pray for...',
                    border: UnderlineInputBorder(borderSide: BorderSide.none)),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            )
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.photo,
                  color: linkColor,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.ellipsis_circle_fill,
                  color: secondaryColor,
                ))
          ],
        ),
      ),
    );
  }
}
