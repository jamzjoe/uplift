import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/your_friends/friends_feed.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/friends_suggestion_bloc/friends_suggestions_bloc_bloc.dart';
import 'package:uplift/utils/widgets/profile_photo.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class FriendSuggestionHorizontal extends StatelessWidget {
  const FriendSuggestionHorizontal({
    super.key,
    required this.currentUser,
  });
  final UserModel currentUser;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendsSuggestionsBlocBloc, FriendsSuggestionsBlocState>(
      builder: (context, state) {
        if (state is FriendsSuggestionLoadingSuccess) {
          final suggestions = state.users;
          if (suggestions.isEmpty) {
            return const SizedBox();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SmallText(
                  text: 'People with same interest like you:', color: lighter),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  itemCount: suggestions.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        final user = suggestions[index];
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          barrierColor: Colors.black.withOpacity(0.5),
                          isScrollControlled: true,
                          enableDrag: true,
                          context: context,
                          builder: (context) {
                            return FriendsFeed(userModel: user, currentUser: currentUser);
                          },
                        );
                      },
                      child: Column(
                        children: [
                          Stack(children: [
                            Positioned(
                                top: 0,
                                bottom: 0,
                                right: 0,
                                left: 0,
                                child: Center(
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor:
                                        primaryColor.withOpacity(0.5),
                                    child: const Icon(
                                      CupertinoIcons.add,
                                      size: 15,
                                      color: whiteColor,
                                    ),
                                  ),
                                )),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: ProfilePhoto(
                                  user: suggestions[index],
                                  radius: 60,
                                ),
                              ),
                            ),
                            const Positioned(
                                top: 0,
                                bottom: 0,
                                right: 0,
                                left: 0,
                                child: Center(
                                  child: Icon(
                                    CupertinoIcons.add,
                                    size: 15,
                                    color: whiteColor,
                                  ),
                                )),
                          ]),
                          Flexible(
                            child: Text(
                              suggestions[index].displayName?.substring(
                                      0,
                                      suggestions[index].displayName!.length < 5
                                          ? suggestions[index]
                                              .displayName!
                                              .length
                                          : 5) ??
                                  '',
                              style: const TextStyle(
                                fontSize: 10,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Divider(
                color: lightColor.withOpacity(0.2),
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
