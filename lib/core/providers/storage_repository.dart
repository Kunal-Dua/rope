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

  Future<List<String>> uploadImage(List<File> files) async {
    final ref = _firebaseStorage.ref().child("images");
    List<String> imageLinks = [];
    for (final file in files) {
      final uploadTask = await ref.putFile(file);
      final snapshot = uploadTask;
      imageLinks.add(await snapshot.ref.getDownloadURL());
    }
    return imageLinks;
  }
}
