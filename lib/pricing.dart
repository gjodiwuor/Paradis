import 'format.dart';
import 'models.dart';

/// The price of a hire, with any discount already worked out.
class Quote {
  const Quote({
    required this.days,
    required this.subtotal,
    required this.discountPercent,
    required this.discount,
    required this.reason,
    required this.bothApply,
  });

  final int days;
  final int subtotal;
  final int discountPercent;
  final int discount;

  /// Which offer was used, for example "15% off, 7 days or more".
  final String reason;

  /// True when the booking qualifies for both offers.
  final bool bothApply;

  int get total => subtotal - discount;
}

/// Works out the price of hiring [vehicle] for [days] days.
///
/// Each company sets two offers. When a booking qualifies for both,
/// only the larger discount is applied.
Quote quoteFor(Vehicle vehicle, Offer offer, int days) {
  final subtotal = vehicle.pricePerDay * days;
  final totalOk = subtotal >= offer.minTotal;
  final daysOk = days >= offer.minDays;

  var percent = 0;
  var reason = '';
  if (totalOk && (!daysOk || offer.totalPercent >= offer.daysPercent)) {
    percent = offer.totalPercent;
    reason = '${offer.totalPercent}% off, ${money(offer.minTotal)} or more';
  } else if (daysOk) {
    percent = offer.daysPercent;
    reason = '${offer.daysPercent}% off, ${offer.minDays} days or more';
  }

  return Quote(
    days: days,
    subtotal: subtotal,
    discountPercent: percent,
    discount: (subtotal * percent / 100).round(),
    reason: reason,
    bothApply: totalOk && daysOk,
  );
}
