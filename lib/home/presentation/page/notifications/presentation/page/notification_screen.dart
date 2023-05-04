import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/notifications/presentation/bloc/notification_bloc/notification_bloc.dart';
import 'package:uplift/home/presentation/page/notifications/presentation/page/notification_shimmer.dart';
import 'package:uplift/utils/services/auth_services.dart';
import 'package:uplift/utils/widgets/header_text.dart';

import 'notification_item.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const HeaderText(text: 'Notifications', color: secondaryColor),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Ionicons.search),
          )
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return ListView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: 15,
                itemBuilder: (context, index) {
                  return const NotificationShimmer();
                });
          }
          if (state is NotificationLoadingSuccess) {
            final data = state.notifications;

            return RefreshIndicator(
              onRefresh: () async {
                final String userID = await AuthServices.userID();
                if (context.mounted) {
                  BlocProvider.of<NotificationBloc>(context)
                      .add(RefreshListOfNotification(userID, false));
                }
              },
              child: ListView.builder(
                  itemCount: state.notifications.length,
                  itemBuilder: (context, index) => NotificationItem(
                        notificationModel: data[index],
                      )),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
