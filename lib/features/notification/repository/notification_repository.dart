import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:rope/core/failure.dart';
import 'package:rope/core/providers/firebase_provider.dart';
import 'package:rope/core/providers/storage_repository.dart';
import 'package:rope/core/type_def.dart';
import 'package:rope/models/notification_model.dart';

final noticationRepositoryProvider = Provider(
  (ref) => NotificationRepository(
    firestore: ref.read(firebaseProvider),
    auth: ref.read(authProvider),
    storageRepository: ref.watch(storageRepositoryProvider),
  ),
);

class NotificationRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final StorageRepository _storageRepository;

  NotificationRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required StorageRepository storageRepository,
  })  : _firestore = firestore,
        _auth = auth,
        _storageRepository = storageRepository;

  CollectionReference get _notifications =>
      _firestore.collection("notifications");
  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<void> createNotification(NotificationModel notification) async {
    try {
      _notifications.add(notification.toMap());
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<NotificationModel>> getLatestNotifications(String uid) {
    return _firestore
        .collection("notifications")
        .where("uid", isEqualTo: uid)
        .snapshots()
        .map((event) {
      List<NotificationModel> doc = [];
      for (var document in event.docs) {
        doc.add(NotificationModel.fromMap(document.data()));
      }
      return doc;
    });
  }
}
