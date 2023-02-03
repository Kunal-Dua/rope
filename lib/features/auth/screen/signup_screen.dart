import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rope/features/auth/screen/login_screen.dart';
import 'package:rope/features/auth/widget/auth_field.dart';
import 'package:rope/features/auth/widget/button.dart';

class SignupView extends ConsumerStatefulWidget {
  const SignupView({super.key});

  @override
  ConsumerState<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends ConsumerState<SignupView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void signup() async {
    // String res = await AuthMethods().signUpUser(
    //   email: _emailController.text,
    //   password: _passwordController.text,
    // );
    // print(res);
  }

  // void logIn() async {
  @override
  Widget build(BuildContext context) {
    var platform = Theme.of(context).platform;
    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Colors.black,
    //     statusBarBrightness: Brightness.light,
    //   ),
    // );
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      // backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: Form(
            child: Column(
              children: [
                const SizedBox(height: 18),
                Image.asset(
                  "assets/images/logo.png",
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 22),
                const Text(
                  "Create new account with us",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 18),
                AuthField(
                  controller: _emailController,
                  label: "Email id",
                  hint: "Enter email id",
                  focus: true,
                ),
                const SizedBox(height: 20),
                AuthField(
                  controller: _passwordController,
                  label: "Password",
                  hint: "Enter password",
                  obsecure: true,
                ),
                const SizedBox(height: 40),
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
