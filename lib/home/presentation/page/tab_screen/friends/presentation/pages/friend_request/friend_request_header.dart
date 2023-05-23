import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/home/presentation/page/tab_screen/friends/presentation/bloc/friend_request_bloc/friend_request_bloc.dart';
import 'package:uplift/utils/services/auth_services.dart';
import 'package:uplift/utils/widgets/header_text.dart';

import '../../../../../../../../constant/constant.dart';
import '../../../../../../../../utils/widgets/default_text.dart';

class FriendRequestHeader extends StatelessWidget {
  const FriendRequestHeader({
    super.key,
    required this.friendRequestCount,
  });
  final int friendRequestCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const HeaderText(
              text: 'Friend request',
              color: darkColor,
              size: 18,
            ),
            const SizedBox(width: 5),
            HeaderText(
                text: friendRequestCount.toString(),
                color: primaryColor,
                size: 18)
          ],
        ),
        GestureDetector(
            onTap: () async => BlocProvider.of<FriendRequestBloc>(context)
                .add(FetchFriendRequestEvent(await AuthServices.userID())),
            child: const DefaultText(text: 'Refresh', color: linkColor))
      ],
    );
  }
}
