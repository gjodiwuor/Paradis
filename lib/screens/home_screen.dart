import 'package:flutter/material.dart';

import '../app_state.dart';
import '../data.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/stars.dart';
import 'company_screen.dart';

/// Screen 2. The car-hire companies, with their area, vehicle count and rating.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return SafeArea(
      bottom: false,
      child: ListenableBuilder(
        listenable: appState,
        builder: (context, _) => ListView(
          padding: EdgeInsets.fromLTRB(16, 12, 16, bottom + 16),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Align(alignment: Alignment.centerLeft, child: LogoTitle(onPhoto: false)),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi ${appState.user.firstName}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Which company are you hiring from?',
                    style: TextStyle(fontSize: 24, height: 1.25, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      const Text(
                        'Car-hire companies',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      Text(
                        '${companies.length} companies',
                        style: const TextStyle(fontSize: 13, color: AppColors.muted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            for (final company in companies) _CompanyCard(company: company),
          ],
        ),
      ),
    );
  }
}

class _CompanyCard extends StatelessWidget {
  const _CompanyCard({required this.company});

  final Company company;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 176,
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.14),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          fit: StackFit.expand,
          children: [
            PhotoWithShade(
              photo: company.photo,
              alignment: company.photoAlign,
              shades: const [0, 0.92],
              stops: const [0.28, 0.92],
            ),
            Positioned(
              left: 16,
              right: 60,
              bottom: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    company.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${company.area} · ${company.vehicles.length} vehicles',
                    style: const TextStyle(
                      color: AppColors.paleBlue,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
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
            Positioned(
              right: 14,
              bottom: 16,
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.chevron_right_rounded, color: AppColors.ink),
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => CompanyScreen(company: company)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
