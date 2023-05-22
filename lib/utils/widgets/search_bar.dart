import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/feed/post_screen/presentation/bloc/get_prayer_request/get_prayer_request_bloc.dart';

class MySearchBar extends StatefulWidget {
  const MySearchBar({super.key, required this.onSubmit});

  final Function(String)? onSubmit;

  @override
  _MySearchBarState createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60.0),
        color: Colors.grey[100],
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.search,
              size: 20,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              onSubmitted: widget.onSubmit,
              decoration: const InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                // Perform search operation based on the value
              },
            ),
          ),
        ],
      ),
    );
  }
}
