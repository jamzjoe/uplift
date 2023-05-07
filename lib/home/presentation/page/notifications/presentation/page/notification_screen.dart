import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/home/presentation/page/notifications/presentation/bloc/notification_bloc/notification_bloc.dart';
import 'package:uplift/home/presentation/page/notifications/presentation/page/notification_shimmer.dart';
import 'package:uplift/utils/services/auth_services.dart';
import 'package:uplift/utils/widgets/default_text.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/no_data_text.dart';

import '../../data/model/notification_model.dart';
import 'notification_item.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key, required this.notifications});

  final List<NotificationModel> notifications;
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
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  onTap: () => markAllAsRead(widget.notifications),
                  child: TextButton.icon(
                      label: const DefaultText(
                          text: 'Mark all as read', color: secondaryColor),
                      onPressed: null,
                      icon: const Icon(
                        Icons.mark_email_read,
                        color: primaryColor,
                      )),
                ),
                PopupMenuItem(
                  child: TextButton.icon(
                      label: const DefaultText(
                          text: 'Delete all', color: secondaryColor),
                      onPressed: () {
                        BlocProvider.of<NotificationBloc>(context)
                            .add(ClearNotification(widget.notifications));
                      },
                      icon: const Icon(
                        Icons.remove_circle,
                        color: primaryColor,
                      )),
                ),
              ];
            },
          )
        ],
      ),
      body: BlocConsumer<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is NotificationLoadingSuccess) {}
        },
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
            if (data.isEmpty) {
              return const Center(
                  child: NoDataMessage(text: 'No notifications yet!'));
            }
            return RefreshIndicator(
              onRefresh: () async {
                final String userID = await AuthServices.userID();
                if (context.mounted) {
                  BlocProvider.of<NotificationBloc>(context)
                      .add(RefreshListOfNotification(userID, false));
                }
              },
              child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
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

  void markAllAsRead(List<NotificationModel> notifications) async {
    log("Tap");
    Future.delayed(const Duration(seconds: 1), () async {
      BlocProvider.of<NotificationBloc>(context)
          .add(ClearNotification(notifications));
    });
  }
}