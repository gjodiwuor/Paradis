import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data.dart';
import '../format.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/buttons.dart';
import '../widgets/common.dart';
import '../widgets/stars.dart';
import 'vehicle_screen.dart';

/// Screen 3. Only this company's vehicles, its two discounts, and a category filter.
class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key, required this.company});

  final Company company;

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final company = widget.company;
    final vehicles = company.vehicles
        .where((v) => _filter == 'All' || v.category == _filter)
        .toList();
    final top = MediaQuery.paddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 290,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    PhotoWithShade(
                      photo: company.photo,
                      alignment: company.photoAlign,
                      shades: const [0.45, 0.05, 0.92],
                      stops: const [0, 0.4, 0.95],
                    ),
                    Positioned(top: top + 8, left: 12, child: const RoundBackButton(onPhoto: true)),
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            company.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                '${company.area} · ${company.vehicles.length} vehicles',
                                style: const TextStyle(color: AppColors.paleBlue, fontSize: 13),
                              ),
                              const SizedBox(width: 8),
                              Stars(filled: company.rating.round(), emptyColor: AppColors.muted),
                              const SizedBox(width: 6),
                              Text(
                                company.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // The light sheet curves up over the bottom of the photo.
              Transform.translate(
                offset: const Offset(0, -28),
                child: Container(
                  padding: const EdgeInsets.only(top: 22),
                  decoration: const BoxDecoration(
                    color: AppColors.ground,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _OffersCard(offer: company.offer),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 64,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                          itemCount: categories.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 8),
                          itemBuilder: (context, i) => _FilterChip(
                            label: categories[i],
                            selected: categories[i] == _filter,
                            onTap: () => setState(() => _filter = categories[i]),
                          ),
                        ),
                      ),
                      if (vehicles.isEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                          child: Text(
                            'No $_filter vehicles at ${company.name} yet.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.muted),
                          ),
                        )
                      else
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            mainAxisExtent: 232,
                          ),
                          itemCount: vehicles.length,
                          itemBuilder: (context, i) =>
                              _VehicleCard(company: company, vehicle: vehicles[i]),
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

class _OffersCard extends StatelessWidget {
  const _OffersCard({required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    Widget item(String title, String detail) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.lightBlue,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(detail, style: const TextStyle(color: AppColors.offerText, fontSize: 12)),
          ],
        );

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.16),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: item(
                    '${offer.totalPercent}% off',
                    'Bookings of ${money(offer.minTotal)} or more',
                  ),
                ),
                const VerticalDivider(color: AppColors.offerLine, width: 28),
                Expanded(
                  child: item(
                    '${offer.daysPercent}% off',
                    'Hires of ${offer.minDays} days or more',
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.offerLine, height: 20),
          const Text(
            'Qualify for both? The larger discount is applied.',
            style: TextStyle(color: AppColors.softBlue, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.black : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: selected ? null : Border.all(color: AppColors.line),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: selected ? 0.26 : 0.06),
                blurRadius: selected ? 14 : 10,
                offset: Offset(0, selected ? 6 : 3),
              ),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : AppColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  const _VehicleCard({required this.company, required this.vehicle});

  final Company company;
  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => VehicleScreen(company: company, vehicle: vehicle),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.asset(
                    vehicle.photo,
                    height: 112,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    alignment: vehicle.photoAlign,
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.ink.withValues(alpha: 0.78),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        vehicle.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 38,
                      child: Text(
                        vehicle.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.3,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Stars(filled: vehicle.rating.round(), size: 13),
                        const SizedBox(width: 5),
                        Text(
                          vehicle.rating.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text.rich(
                      TextSpan(
                        text: money(vehicle.pricePerDay),
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                        children: const [
                          TextSpan(
                            text: ' per day',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
