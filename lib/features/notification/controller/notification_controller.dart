import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rope/core/enums/notification_type_enums%20copy.dart';
import 'package:rope/core/failure.dart';
import 'package:rope/features/notification/repository/notification_repository.dart';
import 'package:rope/models/notification_model.dart';
import 'package:uuid/uuid.dart';
import 'package:rope/core/utils.dart';

final notificationControllerProvider =
    StateNotifierProvider<NotificationController, bool>((ref) {
  return NotificationController(
    notificationRepository: ref.watch(noticationRepositoryProvider),
  );
});

class NotificationController extends StateNotifier<bool> {
  final NotificationRepository _notificationRepository;
  NotificationController(
      {required NotificationRepository notificationRepository})
      : _notificationRepository = notificationRepository,
        super(false);

  void createNotification({
    required String text,
    required String postId,
    required String uid,
    required NotificationType notificationType,
  }) async {
    final newId = const Uuid().v1();
    final notification = Notification(
      uid: uid,
      id: newId,
      text: text,
      postId: postId,
      notificationType: notificationType,
    );
    await _notificationRepository.createNotification(notification);
  }
}
