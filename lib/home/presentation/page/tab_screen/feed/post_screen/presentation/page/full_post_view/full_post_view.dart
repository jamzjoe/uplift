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
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class FullPostView extends StatefulWidget {
  const FullPostView({
    Key? key,
    required this.postModel,
    required this.currentUser,
    required this.allPost,
  }) : super(key: key);

  final PostModel postModel;
  final UserModel currentUser;
  final List<PostModel> allPost;

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
    final allPost = widget.allPost;
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
                  postModel: allPost,
                ),
                PostText(prayerRequest: prayerRequest),
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
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: state.encourages.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: HeaderText(
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
