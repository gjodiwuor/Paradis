import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_state.dart';
import '../theme.dart';
import '../widgets/app_text_field.dart';
import '../widgets/buttons.dart';
import '../widgets/common.dart';
import 'main_shell.dart';

/// A new customer signs up with name, email, phone and password.
class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  void _create() {
    appState.createAccount(name: _name.text, email: _email.text, phone: _phone.text);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShell()),
      (_) => false,
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
              height: height * 0.5,
              child: const PhotoWithShade(
                photo: 'assets/photos/create_account.jpg',
                alignment: Alignment(-1, -0.4),
                shades: [0.6, 0.12, 0.9],
                stops: [0, 0.4, 0.9],
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 4, 20, 0),
                            child: Row(
                              children: [
                                const RoundBackButton(onPhoto: true),
                                const Spacer(),
                                Image.asset(logoAsset, width: 52, height: 52),
                              ],
                            ),
                          ),
                          const Spacer(),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(24, 24, 24, 18),
                            child: Text(
                              'Create your account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(24, 22, 24, 12 + bottomInset),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                AppTextField(label: 'Name', controller: _name, hint: 'Your full name'),
                                const SizedBox(height: 12),
                                AppTextField(
                                  label: 'Email',
                                  controller: _email,
                                  hint: 'you@example.com',
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 12),
                                AppTextField(
                                  label: 'Phone',
                                  controller: _phone,
                                  hint: '+254 7XX XXX XXX',
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(height: 12),
                                AppTextField(
                                  label: 'Password',
                                  controller: _password,
                                  hint: 'Choose a password',
                                  obscure: true,
                                ),
                                const SizedBox(height: 18),
                                PrimaryButton(label: 'Create account', onPressed: _create),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Already have an account?',
                                      style: TextStyle(color: AppColors.muted, fontSize: 14),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text(
                                        'Sign in',
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
