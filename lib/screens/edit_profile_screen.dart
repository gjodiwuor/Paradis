import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../app_state.dart';
import '../theme.dart';
import '../widgets/app_text_field.dart';
import '../widgets/avatar.dart';
import '../widgets/buttons.dart';
import '../widgets/common.dart';

/// Change the name, email, phone, address and photo. Tap the photo to pick a new one.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _user = appState.user;
  late final _name = TextEditingController(text: _user.name);
  late final _email = TextEditingController(text: _user.email);
  late final _phone = TextEditingController(text: _user.phone);
  late final _address = TextEditingController(text: _user.address);
  late String? _photo = _user.photo;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 800);
    if (picked != null) setState(() => _photo = picked.path);
  }

  void _save() {
    appState.updateProfile(_user.copyWith(
      name: _name.text.trim(),
      email: _email.text.trim(),
      phone: _phone.text.trim(),
      address: _address.text.trim(),
      photo: _photo,
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: PrimaryButton(label: 'Save changes', icon: Icons.check_rounded, onPressed: _save),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            const Row(
              children: [
                RoundBackButton(),
                SizedBox(width: 10),
                Text('Edit profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Semantics(
                button: true,
                label: 'Change your profile photo',
                child: GestureDetector(
                  onTap: _pickPhoto,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.ink.withValues(alpha: 0.18),
                          blurRadius: 22,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Avatar(photo: _photo, initials: _user.initials, size: 114),
                          // The shaded strip with a pen shows the photo can be changed.
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 40,
                              width: double.infinity,
                              color: AppColors.ink.withValues(alpha: 0.6),
                              child: const Icon(Icons.edit_outlined, size: 20, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            WhiteCard(
              padding: const EdgeInsets.all(18),
              radius: 22,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(label: 'Name', controller: _name),
                  const SizedBox(height: 12),
                  AppTextField(label: 'Email', controller: _email, keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 12),
                  AppTextField(label: 'Phone', controller: _phone, keyboardType: TextInputType.phone),
                  const SizedBox(height: 12),
                  AppTextField(label: 'Address', controller: _address, hint: 'Street and area'),
                  const SizedBox(height: 8),
                  const Text(
                    'Offered as your pickup location when you book.',
                    style: TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
