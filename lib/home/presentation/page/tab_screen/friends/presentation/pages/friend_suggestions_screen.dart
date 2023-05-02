import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/friends_suggestion_bloc/friends_suggestions_bloc_bloc.dart';
import 'package:uplift/utils/widgets/default_text.dart';

import 'friend_suggestion_list.dart';

class FriendSuggestions extends StatelessWidget {
  const FriendSuggestions({
    super.key,
  });

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
            } else if (state is FriendsSuggestionLoadingSuccess) {
              return FriendSuggestionList(
                users: state.users,
              );
            }
            return const SizedBox();
          },
        )
      ],
    );
  }
}
