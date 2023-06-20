import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:screenshot/screenshot.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_actions.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_comment/presentation/comment_view.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_comment/presentation/encourage_bloc/encourage_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_header.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_text.dart';
import 'package:uplift/utils/widgets/default_loading.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';
import 'package:uplift/utils/widgets/small_text.dart';

import '../post_reactions_counter.dart';

class FullPostView extends StatefulWidget {
  const FullPostView({
    Key? key,
    required this.postModel,
    required this.currentUser,
  }) : super(key: key);

  final PostModel postModel;
  final UserModel currentUser;

  @override
  _FullPostViewState createState() => _FullPostViewState();
}

class _FullPostViewState extends State<FullPostView> {
  final ScreenshotController screenshotController = ScreenshotController();
  final ScrollController scrollController = ScrollController();
  bool showAvatar = false;
  final formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      setState(() {
        showAvatar = true;
      });
    } else if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      setState(() {
        showAvatar = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final prayerRequest = widget.postModel.prayerRequestPostModel;
    final currentUser = widget.currentUser;
    final postModel = widget.postModel;
    final user = widget.postModel.userModel;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              children: [
                PostHeader(
                  isFriendsFeed: true,
                  user: user,
                  prayerRequest: prayerRequest,
                  currentUser: currentUser,
                  postModel: const [],
                ),
                PostText(prayerRequest: prayerRequest),
                PostReactionsCounter(
                    prayerRequest: prayerRequest,
                    currentUser: currentUser,
                    user: user,
                    postModel: widget.postModel),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                PostActions(
                  prayerRequest: prayerRequest,
                  currentUser: currentUser,
                  screenshotController: screenshotController,
                  userModel: user,
                  postModel: postModel,
                  isFullView: true,
                ),
                BlocBuilder<EncourageBloc, EncourageState>(
                  builder: (context, state) {
                    if (state is LoadingEncouragesSuccess) {
                      if (state.encourages.isEmpty) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height - 400,
                          child: const Center(
                            child: SmallText(
                                text: 'No encourages yet', color: darkColor),
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: EdgeInsets.only(
                            bottom:
                                MediaQuery.of(context).viewInsets.bottom + 100),
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: state.encourages.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: SmallText(
                                  text: '${state.encourages.length} encourages',
                                  color: darkColor),
                            );
                          }
                          return CommentItem(
                              encourages: state.encourages, index: index - 1);
                        },
                      );
                    } else {
                      return SizedBox(
                          height: MediaQuery.of(context).size.height - 400,
                          child: const DefaultLoading());
                    }
                  },
                )
              ],
            ),
            Positioned(
              right: 20,
              top: 20,
              child: AnimatedOpacity(
                opacity: showAvatar ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  transform: Matrix4.translationValues(
                      showAvatar ? 0.0 : 0.0, -10.0, 0.0),
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: CircleAvatar(
                      backgroundColor: darkColor.withOpacity(0.2),
                      child: const Icon(Ionicons.close, color: whiteColor),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Form(
        key: formKey,
        child: Container(
          color: whiteColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  validator: (value) =>
                      value!.isEmpty ? 'Add some comment' : null,
                  controller: _commentController,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ProfilePhoto(user: currentUser, size: 20),
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            BlocProvider.of<EncourageBloc>(context).add(
                                AddEncourageEvent(
                                    prayerRequest.postId!,
                                    _commentController.text,
                                    user,
                                    currentUser,
                                    _commentController,
                                    context,
                                    scrollController));
                          }
                        },
                        icon: const Icon(
                          CupertinoIcons.paperplane_fill,
                        )),
                    hintText: 'Add an encourage',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
