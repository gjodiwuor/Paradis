import 'package:flutter/material.dart';

import 'screens/sign_in_screen.dart';
import 'theme.dart';

void main() {
  runApp(const ParadisApp());
}

class ParadisApp extends StatelessWidget {
  const ParadisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paradis',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const SignInScreen(),
    );
  }
}
