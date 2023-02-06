import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rope/core/constants/constants.dart';
import 'package:rope/core/failure.dart';
import 'package:rope/core/providers/firebase_provider.dart';
import 'package:rope/models/user_model.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.read(firebaseProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(signInWithGoogleProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _firestore = firestore,
        _auth = auth,
        _googleSignIn = googleSignIn;

  CollectionReference get _users => _firestore.collection("users");

  Stream<User?> get authStateChange => _auth.authStateChanges();

  Future<Either<String, UserModel>> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      UserModel userModel;

      UserCredential currentUser = await _auth.signInWithCredential(credential);
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
        userModel = await getUserData(currentUser.user!.uid).first;
      }
      return right(userModel);
    } catch (e) {
      return left(e.toString());
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  Future<List<UserModel>> getUserByName(String name) async {
    final document = await _users
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThan: name + 'z')
        .get();

    return document.docs
        .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
