import 'package:flutter/material.dart';

import '../app_state.dart';
import '../widgets/nav_bar.dart';
import 'bookings_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

/// Holds the three tabs (Home, Bookings, Profile) and the bottom bar.
class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: appState.tab,
      builder: (context, index, _) => Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: index,
          children: const [HomeScreen(), BookingsScreen(), ProfileScreen()],
        ),
        bottomNavigationBar: ParadisNavBar(
          currentIndex: index,
          onTap: (i) => appState.tab.value = i,
        ),
      ),
    );
  }
}
