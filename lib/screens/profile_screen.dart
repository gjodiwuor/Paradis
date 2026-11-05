import 'package:flutter/material.dart';

import '../app_state.dart';
import '../theme.dart';
import '../widgets/avatar.dart';
import '../widgets/buttons.dart';
import '../widgets/common.dart';
import 'edit_profile_screen.dart';
import 'sign_in_screen.dart';

/// Screen 7. Name, email, phone, address and sign out.
/// The address here is the one offered when booking.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _edit(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EditProfileScreen()));
  }

  void _signOut(BuildContext context) {
    appState.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SignInScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return SafeArea(
      bottom: false,
      child: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          final user = appState.user;
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  children: [
                    Row(
                      children: [
                        const Text('Profile', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                        const Spacer(),
                        Material(
                          color: Colors.white,
                          shape: const StadiumBorder(side: BorderSide(color: AppColors.line)),
                          child: InkWell(
                            customBorder: const StadiumBorder(),
                            onTap: () => _edit(context),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  Icon(Icons.edit_outlined, size: 16, color: AppColors.blueDark),
                                  SizedBox(width: 6),
                                  Text('Edit profile', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: GestureDetector(
                        onTap: () => _edit(context),
                        child: SizedBox(
                          width: 112,
                          height: 112,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.ink.withValues(alpha: 0.16),
                                      blurRadius: 18,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Avatar(photo: user.photo, initials: user.initials, size: 106),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: AppColors.black,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(Icons.edit_outlined, size: 17, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 16),
                    WhiteCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          _InfoRow(icon: Icons.mail_outline_rounded, label: 'Email', value: user.email),
                          const Divider(height: 1, color: AppColors.line),
                          _InfoRow(icon: Icons.phone_outlined, label: 'Phone', value: user.phone),
                          const Divider(height: 1, color: AppColors.line),
                          _InfoRow(
                            icon: Icons.place_outlined,
                            label: 'Address',
                            value: user.address.isEmpty ? 'No address saved yet' : user.address,
                            note: 'Offered as your pickup location when you book.',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, bottom + 16),
                child: SecondaryButton(
                  label: 'Sign out',
                  icon: Icons.logout_rounded,
                  onPressed: () => _signOut(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value, this.note});

  final IconData icon;
  final String label;
  final String value;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.paleBlue,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 20, color: AppColors.blueDark),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                if (note != null)
                  Text(note!, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
