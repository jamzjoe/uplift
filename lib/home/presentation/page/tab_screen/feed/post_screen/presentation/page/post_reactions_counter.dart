import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/data/model/post_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/page/post_comment/presentation/encourage_bloc/encourage_bloc.dart';
import 'package:uplift/utils/widgets/pop_up.dart';
import 'package:uplift/utils/widgets/small_text.dart';

import '../../data/model/prayer_request_model.dart';
import '../../domain/repository/prayer_request_repository.dart';

class PostReactionsCounter extends StatelessWidget {
  final PrayerRequestPostModel prayerRequest;
  final UserModel currentUser;
  final UserModel user;
  final PostModel postModel;

  const PostReactionsCounter({
    super.key,
    required this.prayerRequest,
    required this.currentUser,
    required this.user,
    required this.postModel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StreamBuilder<Map<String, dynamic>>(
          stream: PrayerRequestRepository().getReactionInfo(
            prayerRequest.postId!,
            currentUser.userId!,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final bool isReacted = snapshot.data!['isReacted'];
              final int reactionCount = snapshot.data!['reactionCount'];
              return Visibility(
                visible: reactionCount != 0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage('assets/prayed.png'),
                      width: 20,
                    ),
                    SmallText(
                      text: getReactionText(
                        isReacted,
                        reactionCount,
                      ),
                      color: lighter,
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
        GestureDetector(
          onTap: () {
            BlocProvider.of<EncourageBloc>(context).add(
              FetchEncourageEvent(prayerRequest.postId!),
            );
            CustomDialog().showComment(
              context,
              currentUser,
              user,
              prayerRequest,
              postModel,
            );
          },
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('Comments')
                .where('post_id', isEqualTo: prayerRequest.postId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Row(
                  children: [
                    Icon(
                      CupertinoIcons.chat_bubble,
                      color: lighter,
                      size: 15,
                    ),
                    SmallText(
                      text: snapshot.data!.size <= 1
                          ? ' ${snapshot.data!.size} encourage'
                          : ' ${snapshot.data!.size} encourages',
                      color: lighter,
                    ),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }

  String getReactionText(bool isReacted, int reactionCount) {
    if (!isReacted && reactionCount == 1) {
      return 'You prayed this';
    } else if (!isReacted && reactionCount > 1) {
      if (reactionCount >= 1000) {
        // Convert count to "k" format
        final int countInK = (reactionCount / 1000).round();
        return 'You and $countInK k other prayed this';
      } else {
        final count = reactionCount - 1;
        return 'You and $count ${count == 1 ? 'other' : 'others'} prayed this';
      }
    } else {
      if (reactionCount >= 1000) {
        // Convert count to "k" format
        final int countInK = (reactionCount / 1000).round();
        return '$countInK k prayed this';
      } else {
        return '$reactionCount prayed this';
      }
    }
  }
}
