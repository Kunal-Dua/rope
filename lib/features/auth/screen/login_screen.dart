import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rope/features/auth/controller/auth_controller.dart';
import 'package:rope/features/auth/screen/signup_screen.dart';
import 'package:rope/features/auth/widget/auth_field.dart';
import 'package:rope/features/auth/widget/button.dart';
import 'package:rope/features/auth/widget/google_sign_in_button.dart';
import 'package:rope/features/auth/widget/square_tile.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void logIn() async {
    ref.watch(authControllerProvider.notifier).logInUser(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    var platform = Theme.of(context).platform;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: MediaQuery.of(context).size.width > 600
                ? EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 3)
                : const EdgeInsets.symmetric(horizontal: 32),
            child: Center(
              child: isLoading
                  ? const CircularProgressIndicator()
                  : Form(
                      key: _formKey,
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
                            "Welcome back you've been missed",
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
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Text(
                                  "Forgot password",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          MyButton(
                            onTap: logIn,
                            text: "Log In",
                            colorText: Colors.white,
                            colorBackground: Colors.blueAccent,
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            "Or continue with",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GoogleSignInButton(),
                              const SizedBox(width: 20),
                              if (platform == TargetPlatform.iOS)
                                SquareTile(
                                  onTap: () {},
                                  imagePath: "assets/images/apple_logo.png",
                                ),
                              const SizedBox(width: 20),
                              SquareTile(
                                onTap: () {},
                                imagePath: "assets/images/facebook_logo.png",
                              ),
                            ],
                          ),
                          const SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Not a member?",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const SignupView(),
                                  ));
                                },
                                child: const Text(
                                  "Register now",
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
        ),
      ),
    );
  }
}
