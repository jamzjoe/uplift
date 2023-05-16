import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/prayer_request_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_comment/domain/comment_repository.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_comment/presentation/encourage_bloc/encourage_bloc.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/just_now.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class CommentView extends StatefulWidget {
  final UserModel currentUser;
  final PrayerRequestPostModel prayerRequestPostModel;
  const CommentView({
    super.key,
    required this.currentUser,
    required this.prayerRequestPostModel,
  });

  @override
  State<CommentView> createState() => _CommentViewState();
}

final _formKey = GlobalKey<FormState>();
final TextEditingController commentController = TextEditingController();
String comment = '';
final User currentUser = FirebaseAuth.instance.currentUser!;

class _CommentViewState extends State<CommentView> {
  @override
  Widget build(BuildContext context) {
    final user = widget.currentUser;
    final PrayerRequestPostModel prayerRequestPostModel =
        widget.prayerRequestPostModel;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: Container(
          // Adjust the height according to your needs
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
              // Add your desired decoration properties
              ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  const HeaderText(
                    text: '693 Encourages',
                    color: secondaryColor,
                    size: 18,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: secondaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              BlocBuilder<EncourageBloc, EncourageState>(
                builder: (context, state) {
                  log(state.toString());
                  if (state is LoadingEncouragesSuccess) {
                    final data = state.encourages;
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 50),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const CircleAvatar(),
                            title: const HeaderText(
                                text: 'Joe Cristian Jamis',
                                color: secondaryColor,
                                size: 16),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SmallText(
                                    text:
                                        "Wow that's nice.... jahfdjhfjksdgfsdng fchmgdhbnc ghcbhgnhv",
                                    color: secondaryColor),
                                SmallText(
                                    text: DateFeature()
                                        .formatDateTime(DateTime.now()),
                                    color: lightColor)
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
        bottomSheet: Container(
          padding: const EdgeInsets.all(4),
          width: double.infinity, // Occupies the full width of the screen
          color: Colors.white, // Customize the background color if needed
          child: Row(
            children: [
              ProfilePhoto(
                user: user,
                radius: 60,
                size: 35,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        comment = value;
                      });
                    },
                    autovalidateMode: AutovalidateMode.always,
                    controller: commentController,
                    decoration:
                        const InputDecoration(hintText: 'Leave encourage...'),
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: comment.isEmpty
                    ? const SizedBox(
                        key: Key('Hider'),
                      )
                    : IconButton(
                        key: const Key('Show'),
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          CommentRepository().addComment(
                              prayerRequestPostModel.postId!,
                              currentUser.uid,
                              commentController.text);
                        },
                        icon: Icon(CupertinoIcons.arrow_up_circle_fill,
                            size: 25,
                            color: comment.isEmpty
                                ? secondaryColor.withOpacity(0.5)
                                : secondaryColor)),
              )
            ],
          ),
        ));
  }
}
