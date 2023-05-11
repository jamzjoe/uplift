import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/bloc/post_prayer_request/post_prayer_request_bloc.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class PostFormScreen extends StatefulWidget {
  const PostFormScreen({super.key, required this.user});
  final UserJoinedModel user;

  @override
  State<PostFormScreen> createState() => _PostFormScreenState();
}

File? file;

class _PostFormScreenState extends State<PostFormScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  Color buttonColor = secondaryColor.withOpacity(0.5);
  @override
  Widget build(BuildContext context) {
    final User user = widget.user.user;
    final UserModel userModel = widget.user.userModel;
    return Form(
      key: _key,
      child: Scaffold(
        appBar: AppBar(
          title: const HeaderText(text: 'Create post', color: secondaryColor),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomContainer(
                  onTap: () {
                    if (_key.currentState!.validate()) {
                      BlocProvider.of<PostPrayerRequestBloc>(context).add(
                          PostPrayerRequestActivity(user, controller.text,
                              file == null ? File('') : file!));
                      setState(() {
                        file = null;
                      });
                      context.pop();
                    }
                  },
                  widget: const DefaultText(text: 'Post', color: whiteColor),
                  color: buttonColor),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ProfilePhoto(user: userModel, radius: 60),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderText(
                        text: user.displayName ?? 'Anonymous User',
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
              Expanded(
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (value) {
                    if (value.length > 5) {
                      setState(() {
                        buttonColor = primaryColor;
                      });
                    } else if (value.length < 5) {
                      setState(() {
                        buttonColor = secondaryColor.withOpacity(0.4);
                      });
                    }
                  },
                  validator: (value) => value!.length < 5 ? '' : null,
                  controller: controller,
                  decoration: const InputDecoration(
                      hintStyle:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
                      hintText: 'Write something you want to pray for...',
                      border:
                          UnderlineInputBorder(borderSide: BorderSide.none)),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
              ),
              file == null
                  ? const SizedBox()
                  : Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: Image.file(
                            file!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                            top: -4,
                            right: -4,
                            child: IconButton(
                              onPressed: () => setState(() {
                                file = null;
                              }),
                              icon: const Icon(CupertinoIcons.delete_left_fill),
                              color: Colors.grey,
                            )),
                      ],
                    ),
              const SizedBox(height: 50)
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
                  onPressed: () async {
                    await PrayerRequestRepository()
                        .imagePicker()
                        .then((value) async {
                      final picked =
                          await PrayerRequestRepository().xFileToFile(value!);
                      setState(() {
                        file = picked;
                      });
                    });
                  },
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
      ),
    );
  }
}
