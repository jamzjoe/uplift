import 'package:flutter/material.dart';
import 'package:uplift/authentication/data/model/user_model.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/data/model/user_mutual_friends_model.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/pages/friend_suggestion/contacts.dart';
import 'package:uplift/utils/widgets/header_text.dart';

import 'add_friend_item.dart';

class FriendSuggestionList extends StatefulWidget {
  const FriendSuggestionList({
    super.key,
    required this.users,
    required this.currentUser,
    required this.context,
  });
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextFormField(
            controller: _searchController,
            onChanged: _search,
            decoration: InputDecoration(
              hintText: 'Search',
              suffixIcon: TextButton.icon(
                  label: const HeaderText(
                      text: 'IMPORT', color: secondaryColor, size: 12),
                  onPressed: () async {
                    final result = await Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const Contacts();
                    }));

                    _search(result);
                    setState(() {
                      _searchController.text = result;
                    });
                  },
                  icon: const Icon(Icons.contact_mail, size: 18)),
            ),
          ),
          Expanded(
            child: filteredUsers.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(
                            filteredUsers[index].userFriendshipModel.userId!),
                        child: AddFriendItem(
                          mutualFriends: filteredUsers[index].mutualFriends,
                          user: filteredUsers[index].userFriendshipModel,
                          currentUser: widget.currentUser,
                          screenContext: widget.context,
                        ),
                      );
                    },
                    itemCount: filteredUsers.length,
                  )
                : const Center(
                    child: Text('No user found'),
                  ),
          ),
        ],
      ),
    );
  }
}
