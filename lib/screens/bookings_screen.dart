import 'package:flutter/material.dart';

import '../app_state.dart';
import '../format.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/stars.dart';
import 'rate_trip_sheet.dart';

/// Screen 6. Upcoming and past trips. A finished trip is rated by tapping stars.
class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return SafeArea(
      bottom: false,
      child: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          final upcoming = appState.upcoming;
          final past = appState.past;
          return ListView(
            padding: EdgeInsets.fromLTRB(16, 12, 16, bottom + 16),
            children: [
              const Text('Bookings', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
              const Text(
                'Upcoming and past trips',
                style: TextStyle(fontSize: 14, color: AppColors.muted),
              ),
              const SizedBox(height: 16),
              const _SectionTitle('Upcoming'),
              if (upcoming.isEmpty)
                const _EmptyNote('No upcoming trips. Pick a company on Home to book one.')
              else
                for (final b in upcoming) _UpcomingCard(booking: b),
              const SizedBox(height: 6),
              const _SectionTitle('Past'),
              if (past.isEmpty)
                const _EmptyNote('Your finished trips will show here.')
              else
                for (final b in past) _PastCard(booking: b),
            ],
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
    );
  }
}

class _EmptyNote extends StatelessWidget {
  const _EmptyNote(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: WhiteCard(
        child: Text(text, style: const TextStyle(fontSize: 14, color: AppColors.muted)),
      ),
    );
  }
}

class _UpcomingCard extends StatelessWidget {
  const _UpcomingCard({required this.booking});

  final Booking booking;

  String get _when {
    final d = daysBetween(today(), booking.pickup);
    if (d > 1) return 'In $d days';
    if (d == 1) return 'Tomorrow';
    if (d == 0) return 'Starts today';
    return 'On the road now';
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = booking.vehicle;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.09),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                vehicle.photo,
                height: 124,
                width: double.infinity,
                fit: BoxFit.cover,
                alignment: vehicle.photoAlign,
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _when,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(vehicle.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                Text(booking.company.name, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
                const SizedBox(height: 8),
                _IconLine(
                  icon: Icons.calendar_today_outlined,
                  text: '${shortDate(booking.pickup)} to ${shortDate(booking.returnDate)} · '
                      '${booking.days} ${booking.days == 1 ? 'day' : 'days'}',
                ),
                const SizedBox(height: 4),
                _IconLine(icon: Icons.place_outlined, text: booking.location),
                const SizedBox(height: 10),
                const DashedLine(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Amount to pay', style: TextStyle(fontSize: 13, color: AppColors.muted)),
                    const Spacer(),
                    Text(
                      money(booking.quote.total),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconLine extends StatelessWidget {
  const _IconLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.blueDark),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
      ],
    );
  }
}

class _PastCard extends StatelessWidget {
  const _PastCard({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final vehicle = booking.vehicle;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: WhiteCard(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                vehicle.photo,
                width: 84,
                height: booking.isRated ? 84 : 100,
                fit: BoxFit.cover,
                alignment: vehicle.photoAlign,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vehicle.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  Text(
                    '${booking.company.name} · ${dayMonth(booking.pickup)} to ${dayMonth(booking.returnDate)}',
                    style: const TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
                  const SizedBox(height: 6),
                  if (booking.isRated) ...[
                    Row(
                      children: [
                        const Text('You rated', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                        const SizedBox(width: 6),
                        Stars(filled: booking.stars!, size: 15),
                      ],
                    ),
                    if ((booking.comment ?? '').isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          booking.comment!,
                          style: const TextStyle(fontSize: 12, color: AppColors.muted),
                        ),
                      ),
                  ] else ...[
                    const Text(
                      'Rate this trip',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.blueDark),
                    ),
                    // Shrinks on narrow phones instead of overflowing.
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          for (var i = 1; i <= 5; i++)
                            SizedBox(
                              width: 44,
                              height: 44,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                tooltip: i == 1 ? 'Rate 1 star' : 'Rate $i stars',
                                icon: const Icon(Icons.star_rounded, size: 28, color: AppColors.fieldBorder),
                                onPressed: () => showRateTripSheet(context, booking, initialStars: i),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
