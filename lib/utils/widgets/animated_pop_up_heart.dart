import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/utils/widgets/pop_up.dart';
import 'package:uplift/utils/widgets/small_text.dart';

import '../../authentication/data/model/user_model.dart';
import '../../home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';

class AnimatedHeartButton extends StatefulWidget {
  final bool isReacted;
  final String postID;
  final UserModel currentUser;
  final UserModel userModel;
  final PostModel postModel;

  const AnimatedHeartButton({
    super.key,
    required this.isReacted,
    required this.postID,
    required this.currentUser,
    required this.userModel,
    required this.postModel,
  });

  @override
  _AnimatedHeartButtonState createState() => _AnimatedHeartButtonState();
}

class _AnimatedHeartButtonState extends State<AnimatedHeartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  DateTime? lastTapTime; // Track the last tap time
  static const Duration intervalDuration =
      Duration(seconds: 2); // Interval duration for spam prevention

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 1.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    final currentTime = DateTime.now();
    if (lastTapTime != null &&
        currentTime.difference(lastTapTime!) < intervalDuration) {
      // Interval is too fast, ban user or take appropriate action
      CustomDialog.showErrorDialog(
        context,
        'Please do not spam react button. Thank you!.',
        'Warning',
        'Understood',
      );
      return;
    }

    lastTapTime = currentTime;

    if (widget.isReacted) {
      addReact(widget.postID, widget.currentUser);
    } else {
      unreact(widget.postID, widget.currentUser);
    }

    _animationController.forward(from: 0).whenComplete(() {
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _handleTap,
      focusColor: primaryColor,
      radius: 200,
      splashColor: primaryColor,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Container(
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Icon(
                    !widget.isReacted
                        ? CupertinoIcons.heart_fill
                        : CupertinoIcons.heart,
                    color: whiteColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 5),
                SmallText(
                  text: widget.isReacted ? 'Pray' : 'Prayed',
                  color: whiteColor,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<bool> addReact(String postID, UserModel currentUser) {
    return PrayerRequestRepository().addReaction(
      postID,
      currentUser.userId!,
      widget.userModel,
      currentUser,
      widget.postModel,
    );
  }

  Future<bool> unreact(String postID, UserModel currentUser) {
    return PrayerRequestRepository().unReact(postID, currentUser.userId!);
  }
}
