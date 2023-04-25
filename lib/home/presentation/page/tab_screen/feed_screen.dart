import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/post_item.dart';
import 'package:uplift/utils/widgets/default_text.dart';

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
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is UserIsIn) {}
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF0F0F0),
        appBar: AppBar(
          title: const Image(
            image: AssetImage('assets/uplift-logo.png'),
            width: 80,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(
                      context: context, delegate: CustomSearchDelegate());
                },
                icon: const Icon(
                  Icons.search,
                  size: 30,
                )),
            IconButton(
                onPressed: goToNotificationScreen,
                icon: const Icon(
                  Icons.notifications,
                  size: 30,
                )),
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
    List<String> matchQuery = [];
    for (var each in searchTerms) {
      if (each.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(each);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: ListTile(
                  dense: true,
                  title: DefaultText(
                      text: matchQuery[index], color: secondaryColor)),
            ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var each in searchTerms) {
      if (each.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(each);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: ListTile(
                  dense: true,
                  title: DefaultText(
                      text: matchQuery[index], color: secondaryColor)),
            ));
  }
}
