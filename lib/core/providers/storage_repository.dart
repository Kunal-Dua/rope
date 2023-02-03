import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rope/core/providers/firebase_provider.dart';

final storageRepositoryProvider = Provider(
  (ref) => StorageRepository(
    firebaseStorage: ref.watch(storageProvider),
  ),
);

class StorageRepository {
  final FirebaseStorage _firebaseStorage;

  StorageRepository({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;

  Future<List<String>> uploadImage(
      {required List<File> images, required String uid}) async {
    Reference ref = _firebaseStorage.ref().child("tweets").child(uid);
    List<String> imageLinks = [];
    for (final file in images) {
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

      final uploadTask =
          await ref.child(uniqueFileName).putFile(File(file.path));
      final snapshot = uploadTask;
      imageLinks.add(await snapshot.ref.getDownloadURL());
    }
    return imageLinks;
  }
}
