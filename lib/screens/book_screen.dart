import 'package:flutter/material.dart';

import '../app_state.dart';
import '../format.dart';
import '../models.dart';
import '../pricing.dart';
import '../theme.dart';
import '../widgets/app_text_field.dart';
import '../widgets/buttons.dart';
import '../widgets/common.dart';
import 'booking_confirmed_screen.dart';

/// Screen 5. Dates, price, any discount, the amount to pay, and the pickup location.
/// With a saved address the customer can use it or enter another;
/// without one they must enter a location.
class BookScreen extends StatefulWidget {
  const BookScreen({super.key, required this.company, required this.vehicle});

  final Company company;
  final Vehicle vehicle;

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  late DateTime _pickup;
  late DateTime _return;
  late bool _useSaved;
  final _otherLocation = TextEditingController();

  String get _savedAddress => appState.user.address;

  int get _days {
    final d = daysBetween(_pickup, _return);
    return d < 1 ? 1 : d;
  }

  String get _location => _useSaved ? _savedAddress : _otherLocation.text.trim();

  @override
  void initState() {
    super.initState();
    _pickup = addDays(today(), 1);
    _return = addDays(_pickup, 7);
    _useSaved = _savedAddress.isNotEmpty;
  }

  @override
  void dispose() {
    _otherLocation.dispose();
    super.dispose();
  }

  Future<void> _pickDates() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: today(),
      lastDate: addDays(today(), 365),
      initialDateRange: DateTimeRange(start: _pickup, end: _return),
      helpText: 'Pickup and return dates',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: AppColors.black,
                onPrimary: Colors.white,
              ),
        ),
        child: child!,
      ),
    );
    if (range == null) return;
    setState(() {
      _pickup = range.start;
      _return = daysBetween(range.start, range.end) < 1 ? addDays(range.start, 1) : range.end;
    });
  }

  void _confirm() {
    final booking = appState.addBooking(
      company: widget.company,
      vehicle: widget.vehicle,
      pickup: _pickup,
      returnDate: _return,
      location: _location,
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => BookingConfirmedScreen(booking: booking)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = widget.vehicle;
    final quote = quoteFor(vehicle, widget.company.offer, _days);
    final canBook = _location.isNotEmpty;

    return Scaffold(
      bottomNavigationBar: _ConfirmBar(
        onConfirm: canBook ? _confirm : null,
        label: canBook ? 'Confirm booking' : 'Enter a location to book',
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
                Text('Book this car', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 14),
            WhiteCard(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      vehicle.photo,
                      width: 96,
                      height: 68,
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
                        Text(widget.company.name, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
                        Text(
                          '${money(vehicle.pricePerDay)} per day',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.blueDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Dates', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.paleBlue,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Text(
                    _days == 1 ? '1 day' : '$_days days',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blueDark,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _DateTile(label: 'Pickup', date: _pickup, onTap: _pickDates)),
                const SizedBox(width: 8),
                Expanded(child: _DateTile(label: 'Return', date: _return, onTap: _pickDates)),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Pickup location', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            if (_savedAddress.isNotEmpty) ...[
              _LocationOption(
                title: 'Use my saved address',
                subtitle: _savedAddress,
                selected: _useSaved,
                onTap: () => setState(() => _useSaved = true),
              ),
              const SizedBox(height: 8),
              _LocationOption(
                title: 'Enter another location',
                selected: !_useSaved,
                onTap: () => setState(() => _useSaved = false),
              ),
              if (!_useSaved) ...[
                const SizedBox(height: 10),
                AppTextField(
                  label: 'Pickup location',
                  controller: _otherLocation,
                  hint: 'Street and area',
                  icon: Icons.place_outlined,
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ] else
              WhiteCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      label: 'Where should the car be handed over?',
                      controller: _otherLocation,
                      hint: 'Street and area',
                      icon: Icons.place_outlined,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'You have no saved address, so a location is needed to book.',
                      style: TextStyle(fontSize: 12, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            _PriceCard(vehicle: vehicle, offer: widget.company.offer, quote: quote),
          ],
        ),
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  const _DateTile({required this.label, required this.date, required this.onTap});

  final String label;
  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.line),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 20, color: AppColors.blueDark),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                  Text(shortDate(date), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationOption extends StatelessWidget {
  const _LocationOption({
    required this.title,
    this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.white : AppColors.ground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: selected ? AppColors.blue : AppColors.line, width: 2),
          ),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: selected ? AppColors.blue : AppColors.fieldBorder, width: 2),
                ),
                child: selected
                    ? Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(color: AppColors.blue, shape: BoxShape.circle),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    if (subtitle != null)
                      Text(subtitle!, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
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

class _PriceCard extends StatelessWidget {
  const _PriceCard({required this.vehicle, required this.offer, required this.quote});

  final Vehicle vehicle;
  final Offer offer;
  final Quote quote;

  @override
  Widget build(BuildContext context) {
    final String note;
    if (quote.bothApply) {
      note = 'Both offers apply, so the larger discount is used.';
    } else if (quote.discount == 0) {
      note = 'Book ${offer.minDays} days or ${money(offer.minTotal)} to get a discount.';
    } else {
      note = '';
    }

    return WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                '${money(vehicle.pricePerDay)} × ${quote.days} ${quote.days == 1 ? 'day' : 'days'}',
                style: const TextStyle(fontSize: 14, color: AppColors.muted),
              ),
              const Spacer(),
              Text(money(quote.subtotal), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
          if (quote.discount > 0) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.paleBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      quote.reason,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blueDark,
                      ),
                    ),
                  ),
                  Text(
                    '− ${money(quote.discount)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blueDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (note.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(note, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
          ],
          const SizedBox(height: 12),
          const DashedLine(),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Amount to pay', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              const Spacer(),
              Text(money(quote.total), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConfirmBar extends StatelessWidget {
  const _ConfirmBar({required this.onConfirm, required this.label});

  final VoidCallback? onConfirm;
  final String label;

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
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                children: [
                  Icon(Icons.place_outlined, size: 16, color: AppColors.blueDark),
                  SizedBox(width: 6),
                  Text(
                    'The car is also returned to this location.',
                    style: TextStyle(fontSize: 13, color: AppColors.muted),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              PrimaryButton(label: label, onPressed: onConfirm),
            ],
          ),
        ),
      ),
    );
  }
}
