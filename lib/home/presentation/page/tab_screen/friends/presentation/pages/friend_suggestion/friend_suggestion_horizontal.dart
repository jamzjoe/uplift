import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/authentication/data/model/user_joined_model.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/same_intention_bloc/same_intentions_suggestion_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/friends_feed.dart';
import 'package:uplift/utils/widgets/capitalize.dart';
import 'package:uplift/utils/widgets/gradient_border_painter.dart';
import 'package:uplift/utils/widgets/keep_alive.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';

class FriendSuggestionHorizontal extends StatefulWidget {
  const FriendSuggestionHorizontal({
    super.key,
    required this.currentUser,
    required this.userJoinedModel,
  });
  final UserModel currentUser;
  final UserJoinedModel userJoinedModel;

  @override
  State<FriendSuggestionHorizontal> createState() =>
      _FriendSuggestionHorizontalState();
}

class _FriendSuggestionHorizontalState
    extends State<FriendSuggestionHorizontal> {
  @override
  Widget build(BuildContext context) {
    return KeepAlivePage(
      child: BlocBuilder<SameIntentionsSuggestionBloc,
          SameIntentionsSuggestionState>(
        builder: (context, state) {
          if (state is LoadingSameIntentionSuccess) {
            final suggestions = state.intentionsAndUser;

            if (suggestions.isEmpty) {
              return Container(
                width: double.infinity,
                color: whiteColor,
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        itemCount: 1,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: CirclePhoto(
                              firstIndex: true,
                              user: widget.currentUser,
                              widget: widget,
                              text: 'Add +', // Adjust the radius as desired
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container(
              width: double.infinity,
              color: whiteColor,
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 90,
                    child: ListView.builder(
                      itemCount: suggestions.length + 1,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // Display an additional circle at index 0
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: CirclePhoto(
                              firstIndex: true,
                              user: widget.currentUser,
                              widget: widget,
                              text: 'Add +', // Adjust the radius as desired
                            ),
                          );
                        } else {
                          final user = suggestions[index - 1].userModel;
                          return Container(
                            width: 60,
                            margin: const EdgeInsets.all(2),
                            child: CirclePhoto(
                              firstIndex: false,
                              user: user,
                              widget: widget,
                              text: user!
                                  .displayName, // Adjust the radius as desired
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

class CirclePhoto extends StatelessWidget {
  const CirclePhoto({
    super.key,
    required this.user,
    required this.widget,
    required this.text,
    this.firstIndex,
  });

  final UserModel? user;
  final FriendSuggestionHorizontal widget;
  final String? text;
  final bool? firstIndex;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (firstIndex ?? false) {
          context.pushNamed('post_field', extra: widget.userJoinedModel);
          return;
        }
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        showFlexibleBottomSheet(
          minHeight: 0,
          initHeight: 0.92,
          maxHeight: 1,
          context: context,
          builder: (context, scrollController, bottomSheetOffset) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [], // Remove the shadow by using an empty list of BoxShadow
              ),
              child: FriendsFeed(
                userModel: user!,
                currentUser: widget.currentUser,
                scrollController: scrollController,
              ),
            );
          },
          anchors: [0, 0.5, 1],
          isSafeArea: true,
        );
      },
      child: Column(
        children: [
          Stack(
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  margin: const EdgeInsets.all(2),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(360),
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: CustomPaint(
                          painter: GradientBorderPainter(
                            gradient: const LinearGradient(
                              colors: [primaryColor, Colors.blue],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            strokeWidth: 1.5,
                            radius: 360.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(7),
                  child: ProfilePhoto(
                    user: user!,
                    radius: 80,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            capitalizeFirstLetter(text ?? ''),
            style: const TextStyle(
              fontSize: 10,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
