import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:rope/core/failure.dart';
import 'package:rope/core/type_def.dart';
import 'package:rope/core/utils.dart';
import 'package:rope/features/auth/repository/auth_repository.dart';
import 'package:rope/models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final getUserDataProvider = FutureProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

final getCurrentUserDataProvider = FutureProvider((ref) {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final userDetails = ref.watch(getUserDataProvider(currentUserId));
  return userDetails.value;
});

final logout = FutureProvider((ref) {
  ref.watch(authRepositoryProvider).logout();
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({
    required AuthRepository authRepository,
    required Ref ref,
  })  : _authRepository = authRepository,
        _ref = ref,
        super(false); //loading

  Stream<User?> get authStateChange => _authRepository.authStateChange;
  final _firebaseAuth = FirebaseAuth.instance;
  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInwithGoogle();
    state = false;
    user.fold((l) => showSnackBar(context, l),
        (r) => _ref.read(userProvider.notifier).update((state) => r));
  }

  void signInWithEmailAndPassword({
    required BuildContext context,
    required String email,
    required String name,
    required String bio,
    required String password,
    File? profileFile,
    File? bannerFile,
  }) async {
    state = true;
    final user = await _authRepository.signUpUser(
      email: email,
      name: name,
      bio: bio,
      password: password,
      profileFile: profileFile!,
      bannerFile: bannerFile!,
    );
    state = false;
    user.fold((l) => showSnackBar(context, l.message),
        (r) => _ref.read(userProvider.notifier).update((state) => r));
  }

  FutureEither<String> logInUser({required email, required password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return right("Success");
    } catch (err) {
      return left(Failure(err.toString()));
    }
  }

  Future<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }
}
