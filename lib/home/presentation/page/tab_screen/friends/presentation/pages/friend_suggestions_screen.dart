import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/friends_suggestion_bloc/friends_suggestions_bloc_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/friends_item_shimmer.dart';
import 'package:uplift/utils/widgets/default_text.dart';

import 'friend_suggestion_list.dart';

class FriendSuggestions extends StatefulWidget {
  const FriendSuggestions({
    super.key,
    required this.currentUser,
  });
  final User currentUser;

  @override
  State<FriendSuggestions> createState() => _FriendSuggestionsState();
}

class _FriendSuggestionsState extends State<FriendSuggestions> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                DefaultText(text: 'Friend suggestions', color: secondaryColor),
              ],
            ),
            const DefaultText(text: 'See more', color: linkColor)
          ],
        ),
        defaultSpace,
        BlocBuilder<FriendsSuggestionsBlocBloc, FriendsSuggestionsBlocState>(
          builder: (context, state) {
            if (state is FriendsSuggestionLoading) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return const FriendsShimmerItem();
                },
              );
            } else if (state is FriendsSuggestionLoadingSuccess) {
              return FriendSuggestionList(
                users: state.users,
                currentUser: widget.currentUser,
              );
            }
            return const SizedBox();
          },
        )
      ],
    );
  }
}
