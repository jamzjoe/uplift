import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_mutual_friends_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/friends_suggestion_bloc/friends_suggestions_bloc_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/friend_suggestion/contacts.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/header_text.dart';

import 'add_friend_item.dart';

class FriendSuggestionList extends StatefulWidget {
  const FriendSuggestionList({
    Key? key,
    required this.users,
    required this.currentUser,
    required this.context,
  }) : super(key: key);

  final List<UserMutualFriendsModel> users;
  final UserModel currentUser;
  final BuildContext context;

  @override
  State<FriendSuggestionList> createState() => _FriendSuggestionListState();
}

class _FriendSuggestionListState extends State<FriendSuggestionList> {
  List<UserMutualFriendsModel> filteredUsers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    filteredUsers = widget.users; // Initialize filteredUsers with all users
    super.initState();
  }

  void _search(String query) {
    setState(() {
      filteredUsers = widget.users.where((user) {
        final displayName = user.userFriendshipModel.displayName;
        final emailAddress = user.userFriendshipModel.emailAddress;
        final phoneNumber = user.userFriendshipModel.phoneNumber;

        return (displayName != null &&
                displayName.toLowerCase().contains(query.toLowerCase())) ||
            (emailAddress != null &&
                emailAddress.toLowerCase().contains(query.toLowerCase())) ||
            (phoneNumber != null && phoneNumber.contains(query));
      }).toList();
    });
  }

  Future<void> _importContacts() async {
    final result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const Contacts();
    }));

    if (result != null) {
      _search(result);
      _searchController.text = result;
    }
  }

  void updateUsers(List<UserMutualFriendsModel> updatedUsers) {
    setState(() {
      filteredUsers = updatedUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FriendsSuggestionsBlocBloc,
        FriendsSuggestionsBlocState>(
      listener: (context, state) {
        if (state is FriendsSuggestionLoadingSuccess) {
          updateUsers(state.users);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomContainer(
              color: whiteColor,
              widget: TextField(
                controller: _searchController,
                onChanged: _search,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                  suffixIcon: TextButton.icon(
                    label: const HeaderText(
                      text: 'IMPORT',
                      color: secondaryColor,
                      size: 12,
                    ),
                    onPressed: _importContacts,
                    icon: const Icon(Icons.contact_mail, size: 18),
                  ),
                ),
              ),
            ),
            Expanded(
              child: filteredUsers.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index].userFriendshipModel;

                        return Dismissible(
                          key: Key(user.userId!),
                          child: AddFriendItem(
                            mutualFriends: filteredUsers[index].mutualFriends,
                            user: user,
                            currentUser: widget.currentUser,
                            screenContext: widget.context,
                          ),
                        );
                      },
                      itemCount: filteredUsers.length,
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                              'No user found, try to add some friends via QR code.'),
                          TextButton(
                              onPressed: () {
                                context.pushNamed('qr_reader',
                                    extra: widget.currentUser);
                              },
                              child: const Text('Scan QR of friends'))
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
