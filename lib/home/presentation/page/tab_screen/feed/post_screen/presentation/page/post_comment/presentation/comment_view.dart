import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/prayer_request_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_comment/data/user_comment_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_comment/presentation/encourage_bloc/encourage_bloc.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/just_now.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class CommentView extends StatefulWidget {
  const CommentView(
      {super.key,
      required this.currentUser,
      required this.prayerRequestPostModel,
      required this.postOwner,
      required this.postModel,
      required this.scrollController});
  final UserModel currentUser;
  final PrayerRequestPostModel prayerRequestPostModel;
  final UserModel postOwner;
  final PostModel postModel;
  final ScrollController scrollController;
  @override
  _CommentViewState createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose(); // Dispose the controller
    super.dispose();
  }

  List<String> comments = [];
  final formKey = GlobalKey<FormState>();

  Widget _showCommentBottomSheet() {
    final prayerRequestPostModel = widget.prayerRequestPostModel;
    final postOwner = widget.postOwner;
    final currentUser = widget.currentUser;

    return Form(
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
                    child: ProfilePhoto(user: widget.currentUser, size: 20),
                  ),
                  suffixIcon: IconButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          BlocProvider.of<EncourageBloc>(context).add(
                              AddEncourageEvent(
                                  prayerRequestPostModel.postId!,
                                  _commentController.text,
                                  postOwner,
                                  currentUser,
                                  _commentController,
                                  context,
                                  widget.scrollController));
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CommentPage(
            scrollController: widget.scrollController,
            postModel: widget.postModel,
            postOwner: widget.postOwner),
        bottomSheet: _showCommentBottomSheet(),
      ),
    );
  }
}

class CommentPage extends StatefulWidget {
  const CommentPage({
    super.key,
    required this.postModel,
    required this.postOwner,
    required this.scrollController,
  });

  final ScrollController scrollController;
  final PostModel postModel;
  final UserModel postOwner;

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EncourageBloc, EncourageState>(
      builder: (context, state) {
        if (state is LoadingEncouragesSuccess) {
          final encourages = state.encourages;
          if (encourages.isEmpty) {
            return GestureDetector(
                onVerticalDragDown: (details) {
                  if (context.canPop()) {
                    context.pop();
                  }
                },
                child: LayoutBuilder(
                  builder: (context, constraints) => ListView(
                    controller: widget.scrollController,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: const Center(
                            child: DefaultText(
                                text: 'No encourages yet', color: darkColor)),
                      )
                    ],
                  ),
                ));
          }
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: HeaderText(
                        text: '${encourages.length} Encourages',
                        color: darkColor),
                  ),
                  IconButton(
                      autofocus: true,
                      focusColor: primaryColor,
                      splashColor: primaryColor,
                      onPressed: () {
                        context.pop();
                      },
                      icon: const Icon(Icons.close)),
                ],
              ),
              ListView.separated(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 100,
                    right: 20,
                    left: 20),
                separatorBuilder: (context, index) => Divider(
                  color: lightColor.withOpacity(0.2),
                  thickness: 0.5,
                ),
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                controller: widget.scrollController,
                itemCount: encourages.length,
                itemBuilder: (context, index) {
                  return CommentItem(encourages: encourages, index: index);
                },
              ),
            ],
          );
        } else if (state is LoadingEncourages) {
          return const Center(
            child: SpinKitFadingCircle(
              color: primaryColor,
              size: 50,
            ),
          );
        }
        return const Center(
          child: SpinKitFadingCircle(
            color: primaryColor,
            size: 50,
          ),
        );
      },
    );
  }
}

class CommentItem extends StatelessWidget {
  const CommentItem({
    super.key,
    required this.encourages,
    required this.index,
  });

  final List<UserCommentModel> encourages;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfilePhoto(user: encourages[index].userModel),
          const SizedBox(width: 15),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HeaderText(
                        text: encourages[index].userModel.displayName!,
                        color: darkColor,
                        size: 16),
                    SmallText(
                        textAlign: TextAlign.start,
                        text: DateFeature().formatDateTime(
                            encourages[index].commentModel.createdAt!.toDate()),
                        color: lightColor)
                  ],
                ),
                SmallText(
                    text: encourages[index].commentModel.commentText!,
                    color: lighter),
              ],
            ),
          )
        ],
      ),
    );
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 5),
      minVerticalPadding: 0,
      leading: ProfilePhoto(
        user: encourages[index].userModel,
        radius: 60,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          HeaderText(
              text: encourages[index].userModel.displayName!,
              color: darkColor,
              size: 16),
          SmallText(
              text: DateFeature().formatDateTime(
                  encourages[index].commentModel.createdAt!.toDate()),
              color: lightColor)
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SmallText(
              text: encourages[index].commentModel.commentText!,
              color: lighter),
        ],
      ),
    );
  }
}
