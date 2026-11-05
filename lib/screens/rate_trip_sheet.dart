import 'package:flutter/material.dart';

import '../app_state.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/app_text_field.dart';
import '../widgets/buttons.dart';

/// Opens the sheet where a finished trip is rated with stars and a comment.
Future<void> showRateTripSheet(BuildContext context, Booking booking, {int initialStars = 4}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => _RateTripSheet(booking: booking, initialStars: initialStars),
  );
}

class _RateTripSheet extends StatefulWidget {
  const _RateTripSheet({required this.booking, required this.initialStars});

  final Booking booking;
  final int initialStars;

  @override
  State<_RateTripSheet> createState() => _RateTripSheetState();
}

class _RateTripSheetState extends State<_RateTripSheet> {
  late int _stars = widget.initialStars;
  final _comment = TextEditingController();

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  void _submit() {
    appState.rateBooking(widget.booking, _stars, _comment.text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = widget.booking.vehicle;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, keyboard + 16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    vehicle.photo,
                    width: 72,
                    height: 60,
                    fit: BoxFit.cover,
                    alignment: vehicle.photoAlign,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('How was your trip?', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
                      Text(
                        '${vehicle.name} · ${widget.booking.company.name}',
                        style: const TextStyle(fontSize: 13, color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 1; i <= 5; i++)
                  IconButton(
                    iconSize: 46,
                    tooltip: i == 1 ? '1 star' : '$i stars',
                    icon: Icon(
                      Icons.star_rounded,
                      color: i <= _stars ? AppColors.amber : AppColors.starEmpty,
                    ),
                    onPressed: () => setState(() => _stars = i),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            AppTextField(
              label: 'Comment',
              controller: _comment,
              hint: 'How were the car and the pickup?',
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            PrimaryButton(label: 'Submit rating', onPressed: _submit),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Not now',
                style: TextStyle(color: AppColors.blueDark, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
