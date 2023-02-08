import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rope/core/common/error_page.dart';
import 'package:rope/core/common/loading_page.dart';
import 'package:rope/features/auth/controller/auth_controller.dart';
import 'package:rope/features/notification/controller/notification_controller.dart';
import 'package:rope/features/notification/widgets/notification_tile.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(getCurrentUserDataProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: currentUser == null
          ? const Loader()
          : ref.watch(getLatestNotifications(currentUser.uid)).when(
                data: (notifications) {
                  return ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (BuildContext context, int index) {
                        final data = notifications[index];
                        return NotificationTile(notification: data);
                      });
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: (() => const Loader()),
              ),
    );
  }
}
