import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rope/core/failure.dart';
import 'package:rope/core/providers/firebase_provider.dart';
import 'package:rope/core/providers/storage_repository.dart';
import 'package:rope/core/type_def.dart';
import 'package:rope/models/user_model.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.read(firebaseProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(signInWithGoogleProvider),
    storageRepository: ref.watch(storageRepositoryProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  // ignore: unused_field
  final GoogleSignIn _googleSignIn;
  final StorageRepository _storageRepository;
  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
    required StorageRepository storageRepository,
  })  : _firestore = firestore,
        _auth = auth,
        _googleSignIn = googleSignIn,
        _storageRepository = storageRepository;

  CollectionReference get _users => _firestore.collection("users");
  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<UserModel> signInwithGoogle() async {
    try {
      UserModel userModel = UserModel(
        uid: '',
        name: '',
        email: '',
        profileUrl: '',
        bio: '',
        bannerPic: '',
        followers: [],
        following: [],
        isTwitterBlue: false,
      );
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        googleProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');

        UserCredential currentUser =
            await _auth.signInWithPopup(googleProvider);
        if (currentUser.additionalUserInfo!.isNewUser) {
          userModel = UserModel(
            uid: currentUser.user!.uid,
            name: currentUser.user!.displayName!,
            email: currentUser.user!.email!,
            profileUrl: currentUser.user!.photoURL!,
            bio: '',
            bannerPic: '',
            followers: [],
            following: [],
            isTwitterBlue: false,
          );

          await _users.doc(currentUser.user!.uid).set(userModel.toMap());
        } else {
          userModel = await getUserData(currentUser.user!.uid);
        }
      } else {
        final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

        final GoogleSignInAuthentication gAuth = await gUser!.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken,
          idToken: gAuth.idToken,
        );

        UserCredential currentUser =
            await _auth.signInWithCredential(credential);
        if (currentUser.additionalUserInfo!.isNewUser) {
          userModel = UserModel(
            uid: currentUser.user!.uid,
            name: currentUser.user!.displayName!,
            email: currentUser.user!.email!,
            profileUrl: currentUser.user!.photoURL!,
            bio: '',
            bannerPic: '',
            followers: [],
            following: [],
            isTwitterBlue: false,
          );

          await _users.doc(currentUser.user!.uid).set(userModel.toMap());
        } else {
          userModel = await getUserData(currentUser.user!.uid);
        }
      }
      return right(userModel);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<UserModel> getUserData(String uid) async {
    final document = await _users.doc(uid).get();
    return UserModel.fromMap(document.data() as Map<String, dynamic>);
  }

  Future<List<UserModel>> getUserByName(String name) async {
    final document =
        await _users.where('name', isLessThanOrEqualTo: name).get();

    return document.docs
        .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  FutureEither<void> updateUserProfilePic(
      {required UserModel userModel, required String profileUrl}) async {
    try {
      final doc = await _users.doc(userModel.uid).update({
        "profileUrl": profileUrl,
      });
      return right(doc);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<void> updateUserBannerPic(
      {required UserModel userModel, required String bannerPic}) async {
    try {
      final doc = await _users.doc(userModel.uid).update({
        "bannerPic": bannerPic,
      });
      return right(doc);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<void> updateUserProfileName(
      {required UserModel userModel, required String name}) async {
    try {
      final doc = await _users.doc(userModel.uid).update({
        "name": name,
      });
      return right(doc);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<void> updateUserProfileBio(
      {required UserModel userModel, required String bio}) async {
    try {
      final doc = await _users.doc(userModel.uid).update({
        "bio": bio,
      });
      return right(doc);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<void> updateUserToVerified(
      {required UserModel userModel, required bool verified}) async {
    try {
      final doc = await _users.doc(userModel.uid).update({
        "isTwitterBlue": verified,
      });
      return right(doc);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel> getUpdatedUserProfileData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureEither<void> addToFollowers({required UserModel user}) async {
    try {
      await _users.doc(user.uid).update({
        "followers": user.followers,
      });
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<void> addToFollowing({required UserModel user}) async {
    try {
      await _users.doc(user.uid).update({
        "following": user.following,
      });
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> signUpUser({
    required String email,
    required String name,
    required String bio,
    required String password,
    File? profileFile,
    File? bannerFile,
  }) async {
    try {
      UserCredential currentUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String profileUrl;
      if (profileFile != null) {
        final profile =
            await _storageRepository.uploadImage(images: ([profileFile]));
        profileUrl = profile[0];
      } else {
        profileUrl =
            "https://icon-library.com/images/default-user-icon/default-user-icon-8.jpg";
      }

      String bannerUrl = '';
      if (bannerFile != null) {
        final banner =
            await _storageRepository.uploadImage(images: ([profileFile!]));
        bannerUrl = banner[0];
      }

      UserModel userModel;

      userModel = UserModel(
        uid: currentUser.user!.uid,
        name: name,
        email: email,
        profileUrl: profileUrl,
        bio: bio,
        bannerPic: bannerUrl,
        isTwitterBlue: false,
        followers: [],
        following: [],
      );
      await _users.doc(currentUser.user!.uid).set(userModel.toMap());

      return right(userModel);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<void> logout() async {
    final doc = _auth.signOut();
    return right(doc);
  }
}
