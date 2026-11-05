import 'package:flutter/material.dart';

import '../theme.dart';

/// Five stars with the first [filled] of them coloured in.
class Stars extends StatelessWidget {
  const Stars({
    super.key,
    required this.filled,
    this.size = 14,
    this.emptyColor = AppColors.starEmpty,
  });

  final int filled;
  final double size;
  final Color emptyColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$filled out of 5 stars',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < 5; i++)
            Icon(
              Icons.star_rounded,
              size: size,
              color: i < filled ? AppColors.amber : emptyColor,
            ),
        ],
      ),
    );
  }
}
