import 'dart:io';

import 'package:flutter/material.dart';

import '../theme.dart';

/// A round profile picture. Shows the person's initials when there is no photo.
class Avatar extends StatelessWidget {
  const Avatar({super.key, required this.photo, required this.initials, this.size = 112});

  /// An asset path, a file path from the gallery, or null.
  final String? photo;
  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    final path = photo;
    if (path == null) {
      return Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: const BoxDecoration(color: AppColors.blue, shape: BoxShape.circle),
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.3,
            fontWeight: FontWeight.w800,
          ),
        ),
      );
    }
    final ImageProvider image =
        path.startsWith('assets/') ? AssetImage(path) : FileImage(File(path));
    return ClipOval(
      child: Image(image: image, width: size, height: size, fit: BoxFit.cover),
    );
  }
}
