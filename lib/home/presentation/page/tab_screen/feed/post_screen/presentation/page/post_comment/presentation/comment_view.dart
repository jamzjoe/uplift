import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/prayer_request_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_comment/presentation/encourage_bloc/encourage_bloc.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/just_now.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';
import 'package:uplift/utils/widgets/small_text.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class CommentView extends StatefulWidget {
  final UserModel postUser;
  final PrayerRequestPostModel prayerRequestPostModel;
  final UserModel currentUser;
  const CommentView({
    super.key,
    required this.postUser,
    required this.prayerRequestPostModel,
    required this.currentUser,
  });

  @override
  State<CommentView> createState() => _CommentViewState();
}

final _formKey = GlobalKey<FormState>();
final TextEditingController commentController = TextEditingController();
String comment = '';
int commentCount = 0;
ScrollController _scrollController = ScrollController();
late StreamSubscription<bool> keyboardSubscription;

var keyboardVisibilityController = KeyboardVisibilityController();

class _CommentViewState extends State<CommentView> {
  @override
  void initState() {
    // Query
    log('Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');

    // Subscribe
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      log('Keyboard visibility update. Is visible: $visible');
    });
    super.initState();
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postUser = widget.postUser;
    final currentUser = widget.currentUser;
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
                  HeaderText(
                    text: '$commentCount Encourages',
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
              BlocConsumer<EncourageBloc, EncourageState>(
                listener: (context, state) {
                  if (state is LoadingEncouragesSuccess) {
                    setState(() {
                      commentCount = state.encourages.length;
                    });
                  }
                },
                builder: (context, state) {
                  log(state.toString());
                  if (state is LoadingEncouragesSuccess) {
                    final data = state.encourages;
                    if (data.isEmpty) {
                      return const Expanded(
                        child: Center(
                          child: DefaultText(
                              text: 'No encourages yet...',
                              color: secondaryColor),
                        ),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(bottom: 50),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            minVerticalPadding: 0,
                            leading: ProfilePhoto(
                              user: data[index].userModel,
                              radius: 60,
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                HeaderText(
                                    text: data[index].userModel.displayName!,
                                    color: secondaryColor,
                                    size: 16),
                                SmallText(
                                    text: DateFeature().formatDateTime(
                                        data[index]
                                            .commentModel
                                            .createdAt!
                                            .toDate()),
                                    color: lightColor)
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SmallText(
                                    text: data[index].commentModel.commentText!,
                                    color: secondaryColor),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state is LoadingEncourages) {
                    return const CommentShimmerLoading();
                  }
                  return const Expanded(
                    child: Center(
                      child: DefaultText(
                          text: 'Something went wrong...',
                          color: secondaryColor),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        bottomSheet: BackdropFilter(
          filter: keyboardVisibilityController.isVisible
              ? ColorFilter.mode(
                  secondaryColor.withOpacity(0.2), BlendMode.darken)
              : ColorFilter.mode(
                  secondaryColor.withOpacity(0), BlendMode.darken),
          child: Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity, // Occupies the full width of the screen
            color: Colors.white, // Customize the background color if needed
            child: Row(
              children: [
                ProfilePhoto(
                  user: currentUser,
                  radius: 60,
                  size: 35,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      onTap: () async {
                        scrollToBottom();
                      },
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
                          key: Key('Hide'),
                        )
                      : IconButton(
                          key: const Key('Show'),
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            BlocProvider.of<EncourageBloc>(context).add(
                                AddEncourageEvent(
                                    prayerRequestPostModel.postId!,
                                    commentController.text,
                                    postUser,
                                    currentUser));
                            // Scroll to the bottom after adding the new item
                            commentController.clear();
                            scrollToBottom();
                          },
                          icon: Icon(CupertinoIcons.arrow_up_circle_fill,
                              size: 25,
                              color: comment.isEmpty
                                  ? secondaryColor.withOpacity(0.5)
                                  : secondaryColor)),
                )
              ],
            ),
          ),
        ));
  }

  Future<void> scrollToBottom() {
    return _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}

class CommentShimmerLoading extends StatelessWidget {
  const CommentShimmerLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return const CommentShimmerItem();
          }),
    );
  }
}

class CommentShimmerItem extends StatelessWidget {
  const CommentShimmerItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: secondaryColor.withOpacity(0.2),
      highlightColor: secondaryColor.withOpacity(0.1),
      child: ListTile(
        minVerticalPadding: 0,
        leading: const CircleAvatar(radius: 25),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Expanded(
              child: CustomContainer(widget: SizedBox(), color: secondaryColor),
            ),
            SizedBox(width: 5),
            CustomContainer(widget: SizedBox(), color: secondaryColor),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            CustomContainer(
                width: double.infinity,
                widget: SizedBox(),
                color: secondaryColor),
          ],
        ),
      ),
    );
  }
}
