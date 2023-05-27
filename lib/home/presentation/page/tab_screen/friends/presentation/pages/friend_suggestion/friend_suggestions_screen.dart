import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/friends_suggestion_bloc/friends_suggestions_bloc_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/friend_suggestion/contacts.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/friend_suggestion/friend_suggestion_list.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/friends_item_shimmer.dart';
import 'package:uplift/utils/widgets/default_loading.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/no_data_text.dart';

class FriendSuggestions extends StatefulWidget {
  const FriendSuggestions({
    super.key,
    required this.currentUser,
  });
  final UserModel currentUser;

  @override
  State<FriendSuggestions> createState() => _FriendSuggestionsState();
}

final TextEditingController searchController = TextEditingController();

class _FriendSuggestionsState extends State<FriendSuggestions> {
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: WillPopScope(
        onWillPop: () async {
          searchController.clear();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            
            title: const HeaderText(
              text: 'Friend suggestions',
              color: darkColor,
              size: 18,
            ),
          ),
          body: BlocBuilder<FriendsSuggestionsBlocBloc,
              FriendsSuggestionsBlocState>(
            builder: (context, state) {
              if (state is FriendsSuggestionLoading) {
                return const Center(
                  child: DefaultLoading(),
                );
              } else if (state is FriendsSuggestionLoadingSuccess) {
                if (state.users.isEmpty) {
                  return const Align(
                    alignment: Alignment.center,
                    child: NoDataMessage(text: 'No user found'),
                  );
                }
                return FriendSuggestionList(
                    users: state.users,
                    currentUser: widget.currentUser,
                    context: context);
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  void search(BuildContext context, String query) {
    BlocProvider.of<FriendsSuggestionsBlocBloc>(context)
        .add(SearchFriendSuggestions(query));
  }
}
