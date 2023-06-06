import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/small_text.dart';

import '../../authentication/data/model/user_model.dart';
import '../../home/presentation/page/tab_screen/feed/post_screen/domain/repository/prayer_request_repository.dart';

class AnimatedHeartButton extends StatefulWidget {
  final bool isReacted;
  final String postID;
  final UserModel currentUser;
  final UserModel userModel;

  const AnimatedHeartButton({super.key, 
    required this.isReacted,
    required this.postID,
    required this.currentUser, required this.userModel,
  });

  @override
  _AnimatedHeartButtonState createState() => _AnimatedHeartButtonState();
}

class _AnimatedHeartButtonState extends State<AnimatedHeartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 1).animate(
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
    if (widget.isReacted) {
      addReact(widget.postID, widget.currentUser);
    } else {
      unreact(widget.postID, widget.currentUser);
    }

    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _handleTap,
      focusColor: primaryColor,
      radius: 100,
      splashColor: primaryColor,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    !widget.isReacted
                        ? CupertinoIcons.heart_fill
                        : CupertinoIcons.heart,
                    color: whiteColor,
                    size: 20,
                  ),
                  const SizedBox(width: 5),
                  SmallText(
                    text: widget.isReacted ? 'Pray' : 'Prayed',
                    color: whiteColor,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  
  Future<bool> addReact(String postID, UserModel currentUser) {
    return PrayerRequestRepository().addReaction(
        postID, currentUser.userId!, widget.userModel, currentUser);
  }

  Future<bool> unreact(String postID, UserModel currentUser) {
    return PrayerRequestRepository().unReact(postID, currentUser.userId!);
  }
}
