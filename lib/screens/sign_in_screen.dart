import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_state.dart';
import '../theme.dart';
import '../widgets/app_text_field.dart';
import '../widgets/buttons.dart';
import '../widgets/common.dart';
import 'create_account_screen.dart';
import 'main_shell.dart';

/// Screen 1. Email and password. Any details sign in as the sample customer.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _signIn() {
    appState.signIn(_email.text);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.ink,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: height * 0.66,
              child: const PhotoWithShade(
                photo: 'assets/photos/road.jpg',
                alignment: Alignment(0.6, 0),
                shades: [0.62, 0.1, 0.9],
                stops: [0, 0.36, 0.92],
              ),
            ),
            SafeArea(
              bottom: false,
              child: LayoutBuilder(
                builder: (context, box) => SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: box.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(24, 12, 24, 0),
                            child: Align(alignment: Alignment.centerLeft, child: LogoTitle()),
                          ),
                          const Spacer(),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pick a company.\nBook the car.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 34,
                                    height: 1.18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Every company and its cars, in one app.',
                                  style: TextStyle(color: AppColors.offerText, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(24, 24, 24, 12 + bottomInset),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  'Welcome back',
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 14),
                                AppTextField(
                                  label: 'Email',
                                  controller: _email,
                                  hint: 'you@example.com',
                                  icon: Icons.mail_outline_rounded,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 14),
                                AppTextField(
                                  label: 'Password',
                                  controller: _password,
                                  hint: 'Your password',
                                  icon: Icons.lock_outline_rounded,
                                  obscure: true,
                                ),
                                const SizedBox(height: 18),
                                PrimaryButton(label: 'Sign in', onPressed: _signIn),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'New to Paradis?',
                                      style: TextStyle(color: AppColors.muted, fontSize: 14),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).push(
                                        MaterialPageRoute(builder: (_) => const CreateAccountScreen()),
                                      ),
                                      child: const Text(
                                        'Create an account',
                                        style: TextStyle(
                                          color: AppColors.blueDark,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
