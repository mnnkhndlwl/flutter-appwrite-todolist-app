import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/common/common.dart';
import 'package:todo/constants/constants.dart';
import 'package:todo/features/auth/controllers/auth_controller.dart';
import 'package:todo/features/auth/view/login_view.dart';
import 'package:todo/features/auth/widgets/auth_field.dart';
import 'package:todo/theme/theme.dart';

class SignUpView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignUpView(),
      );
  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  final appbar = UIConstants.appBar();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void onSignUp() {
    final res = ref.read(authControllerProvider.notifier).signUp(
        email: emailController.text,
        password: passwordController.text,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: appbar,
      body: isLoading
          ? const LoadingPage()
          : Center(
              child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // textfield 1
                    AuthField(
                      controller: emailController,
                      hintText: 'Email',
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    // textfield 2
                    AuthField(
                      controller: passwordController,
                      hintText: 'Password',
                    ),
                    // button
                    const SizedBox(
                      height: 25,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: RoundedSmallButton(onTap: onSignUp, label: 'Done'),
                    ),
                    //textspan
                    const SizedBox(
                      height: 40,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Already have an account ? ",
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: ' Login',
                            style: const TextStyle(color: Pallete.blueColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  LoginView.route(),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
    );
  }
}