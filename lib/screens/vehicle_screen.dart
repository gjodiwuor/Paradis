import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../format.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/buttons.dart';
import '../widgets/common.dart';
import '../widgets/stars.dart';
import 'book_screen.dart';

/// Screen 4. Category, seats, transmission, price per day, rating and recent reviews.
class VehicleScreen extends StatelessWidget {
  const VehicleScreen({super.key, required this.company, required this.vehicle});

  final Company company;
  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: _BookBar(company: company, vehicle: vehicle),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 330,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    PhotoWithShade(
                      photo: vehicle.photo,
                      alignment: vehicle.photoAlign,
                      shades: const [0.5, 0],
                      stops: const [0, 0.36],
                    ),
                    Positioned(top: top + 8, left: 12, child: const RoundBackButton(onPhoto: true)),
                  ],
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -28),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle.name,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${company.name} · ${company.area}',
                        style: const TextStyle(fontSize: 14, color: AppColors.muted),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          _SpecTile(icon: Icons.terrain_outlined, value: vehicle.category, label: 'Category'),
                          const SizedBox(width: 8),
                          _SpecTile(icon: Icons.event_seat_outlined, value: '${vehicle.seats} seats', label: 'Seats'),
                          const SizedBox(width: 8),
                          _SpecTile(icon: Icons.settings_outlined, value: vehicle.transmission, label: 'Transmission'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.ink,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            Text(
                              vehicle.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 38,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stars(filled: vehicle.rating.round(), size: 18),
                                Text(
                                  '${vehicle.ratingCount} ratings',
                                  style: const TextStyle(color: AppColors.softBlue, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Recent reviews',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 96,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: vehicle.reviews.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 10),
                          itemBuilder: (context, i) => _ReviewCard(review: vehicle.reviews[i]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpecTile extends StatelessWidget {
  const _SpecTile({required this.icon, required this.value, required this.label});

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.ground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: AppColors.blueDark),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 256,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.ground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(review.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              const Spacer(),
              Stars(filled: review.stars, size: 13),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            review.comment,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _BookBar extends StatelessWidget {
  const _BookBar({required this.company, required this.vehicle});

  final Company company;
  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    money(vehicle.pricePerDay),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  const Text('per day', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: 196,
                child: PrimaryButton(
                  label: 'Book this car',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BookScreen(company: company, vehicle: vehicle),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
