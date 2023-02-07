import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rope/core/constants/constants.dart';
import 'package:rope/core/utils.dart';
import 'package:rope/features/auth/controller/auth_controller.dart';
import 'package:rope/features/auth/screen/login_screen.dart';
import 'package:rope/features/auth/widget/auth_field.dart';
import 'package:rope/features/auth/widget/button.dart';
import 'package:rope/theme/pallete.dart';

class SignupView extends ConsumerStatefulWidget {
  const SignupView({super.key});

  @override
  ConsumerState<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends ConsumerState<SignupView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  File? profileFile;
  File? bannerFile;

  void selectBannerImage() async {
    final banner = await pickImage();
    if (banner != null) {
      setState(() {
        bannerFile = banner;
      });
    }
  }

  void selectProfileImage() async {
    final img = await pickImage();
    if (img != null) {
      setState(() {
        profileFile = img;
      });
    }
  }

  void signup() async {
    if (profileFile == null) {
      showSnackBar(context, "Select Profil");
    }
    ref.read(authControllerProvider.notifier).signInWithEmailAndPassword(
        context: context,
        email: _emailController.text,
        name: _nameController.text,
        bio: _bioController.text,
        password: _passwordController.text,
        profileFile: profileFile,
        bannerFile: bannerFile);
  }

  @override
  Widget build(BuildContext context) {
    // var platform = Theme.of(context).platform;
    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Colors.black,
    //     statusBarBrightness: Brightness.light,
    //   ),
    // );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Form(
            child: Column(
              children: [
                const SizedBox(height: 4),
                Image.asset(
                  Constants.appLogo,
                  width: 100,
                  height: 100,
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Upload profile image"),
                      const SizedBox(width: 14),
                      GestureDetector(
                        onTap: selectProfileImage,
                        child: profileFile != null
                            ? CircleAvatar(
                                backgroundImage: FileImage(profileFile!),
                                radius: 20,
                              )
                            : const CircleAvatar(
                                backgroundImage: AssetImage(
                                    Constants.defaultPictureIconPath),
                                radius: 20,
                              ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Upload banner image"),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: selectBannerImage,
                        child: bannerFile != null
                            ? CircleAvatar(
                                backgroundImage: FileImage(bannerFile!),
                                radius: 20,
                              )
                            : const CircleAvatar(
                                backgroundImage: AssetImage(
                                    Constants.defaultPictureIconPath),
                                radius: 20,
                              ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  "Create new account with us",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                AuthField(
                  controller: _emailController,
                  label: "Email id",
                  hint: "Enter email id",
                  focus: true,
                ),
                const SizedBox(height: 10),
                AuthField(
                  controller: _passwordController,
                  label: "Password",
                  hint: "Enter password",
                  obsecure: true,
                ),
                const SizedBox(height: 10),
                AuthField(
                  controller: _nameController,
                  label: "Username",
                  hint: "Enter username",
                ),
                const SizedBox(height: 10),
                AuthField(
                  controller: _bioController,
                  label: "Bio",
                  hint: "Enter bio",
                ),
                const SizedBox(height: 10),
                MyButton(
                  text: "Sign Up",
                  colorText: Colors.white,
                  colorBackground: Colors.blueAccent,
                  onTap: signup,
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already a member?",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ));
                      },
                      child: const Text(
                        "Log in now",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
