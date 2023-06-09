import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/common/common.dart';
import 'package:todo/common/loading_page.dart';
import 'package:todo/constants/ui_constants.dart';
import 'package:todo/features/auth/controllers/auth_controller.dart';
import 'package:todo/features/auth/view/signup_view.dart';
import 'package:todo/features/auth/widgets/auth_field.dart';

import '../../../theme/theme.dart';

class LoginView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LoginView(),
      );
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
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

  void onLogin() {
    ref.read(authControllerProvider.notifier).login(
          email: emailController.text,
          password: passwordController.text,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: appbar,
      body: isLoading
          ? const Loader()
          : Center(
              child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
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
                      child: RoundedSmallButton(onTap: onLogin, label: 'Done'),
                    ),
                    //textspan
                    const SizedBox(
                      height: 40,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Done have an account ? ",
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: ' Sign up',
                            style: const TextStyle(color: Pallete.blueColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  SignUpView.route(),
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