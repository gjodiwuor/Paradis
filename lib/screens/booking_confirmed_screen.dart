import 'package:flutter/material.dart';

import '../app_state.dart';
import '../format.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/buttons.dart';
import '../widgets/common.dart';

/// Shown after Confirm booking. The trip now appears under Upcoming.
class BookingConfirmedScreen extends StatelessWidget {
  const BookingConfirmedScreen({super.key, required this.booking});

  final Booking booking;

  void _backToTab(BuildContext context, int tab) {
    appState.tab.value = tab;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // The faded beach photo behind the page.
          Positioned.fill(
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/photos/nyali_beach.jpg',
                fit: BoxFit.cover,
                alignment: const Alignment(0.7, 0),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.blue,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: const Icon(Icons.check_rounded, color: Colors.white, size: 32),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Booking confirmed',
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Your trip is listed under Upcoming.',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF2B3750)),
                        ),
                        const SizedBox(height: 18),
                        _Ticket(booking: booking),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Column(
                    children: [
                      PrimaryButton(label: 'View my bookings', onPressed: () => _backToTab(context, 1)),
                      const SizedBox(height: 10),
                      SecondaryButton(label: 'Back to Home', onPressed: () => _backToTab(context, 0)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Ticket extends StatelessWidget {
  const _Ticket({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final vehicle = booking.vehicle;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.18),
            blurRadius: 34,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            vehicle.photo,
            height: 148,
            width: double.infinity,
            fit: BoxFit.cover,
            alignment: vehicle.photoAlign,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(vehicle.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                Text(booking.company.name, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: DashedLine(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: LabelValue(label: 'Pickup', value: shortDate(booking.pickup))),
                    Expanded(child: LabelValue(label: 'Return', value: shortDate(booking.returnDate))),
                  ],
                ),
                const SizedBox(height: 12),
                LabelValue(label: 'Pickup and return location', value: booking.location),
                const SizedBox(height: 12),
                LabelValue(label: 'Amount to pay', value: money(booking.quote.total), big: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
