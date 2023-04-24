import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/home/presentation/page/post_item.dart';

import '../post_field.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key, required this.user});
  final User user;

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final User user = widget.user;
    return Scaffold(
      backgroundColor: const Color(0xffF0F0F0),
      appBar: AppBar(
        title: const Image(
          image: AssetImage('assets/uplift-logo.png'),
          width: 80,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
              },
              child: const Icon(
                Icons.search,
                size: 30,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 10),
            child: GestureDetector(
              onTap: goToNotificationScreen,
              child: const Icon(
                Icons.notifications,
                size: 30,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          PostField(user: user),
          Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  itemBuilder: (context, index) => const PostItem()))
        ],
      ),
    );
  }

  void goToNotificationScreen() {
    context.pushNamed('notification');
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = ['Test', 'Joe'];
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Ionicons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Ionicons.search));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return ListView.builder(
        itemBuilder: (context, index) => const Text('test'));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return ListView.builder(
        itemBuilder: (context, index) => const Text('test'));
  }
}
