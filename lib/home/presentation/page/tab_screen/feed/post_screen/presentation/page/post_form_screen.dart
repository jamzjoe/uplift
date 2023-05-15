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

class _PostFormScreenState extends State<PostFormScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();

  List<File> file = [];
  Color buttonColor = secondaryColor.withOpacity(0.5);
  @override
  Widget build(BuildContext context) {
    final User user = widget.user.user;
    final UserModel userModel = widget.user.userModel;

    return BlocListener<PostPrayerRequestBloc, PostPrayerRequestState>(
      listener: (context, state) {
        if (state is PostPrayerRequestSuccess) {}
      },
      child: Form(
        key: _key,
        child: Scaffold(
          appBar: AppBar(
            title: const HeaderText(text: 'Create post', color: secondaryColor),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomContainer(
                    onTap: () async {
                      final List<File> files = file;
                      if (_key.currentState!.validate()) {
                        BlocProvider.of<PostPrayerRequestBloc>(context).add(
                            PostPrayerRequestActivity(
                                user, controller.text, files, ''));

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
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 20),
                        hintText: 'Write something you want to pray for...',
                        border:
                            UnderlineInputBorder(borderSide: BorderSide.none)),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                file.isEmpty
                    ? const SizedBox()
                    : Wrap(
                        runSpacing: 10,
                        direction: Axis.horizontal,
                        spacing: 10,
                        children: [
                          ...file.map((e) => GestureDetector(
                                onHorizontalDragUpdate: (details) {
                                  setState(() {
                                    file.remove(e);
                                  });
                                },
                                child: Container(
                                  width: file.length > 3 ? 60 : 100,
                                  height: file.length > 3 ? 60 : 100,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Image.file(
                                    e,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ))
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
                          file.add(picked);
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
      ),
    );
  }
}
