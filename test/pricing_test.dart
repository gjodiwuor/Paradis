import 'package:flutter_test/flutter_test.dart';
import 'package:paradis/data.dart';
import 'package:paradis/format.dart';
import 'package:paradis/pricing.dart';

void main() {
  // Savanna Drive: 10% off from KSh 30,000, 15% off from 7 days.
  final offer = companies.first.offer;

  test('a short, cheap hire gets no discount', () {
    final q = quoteFor(prado, offer, 2);
    expect(q.subtotal, 24000);
    expect(q.discount, 0);
    expect(q.total, 24000);
  });

  test('only the total offer applies', () {
    final q = quoteFor(prado, offer, 3);
    expect(q.subtotal, 36000);
    expect(q.discountPercent, 10);
    expect(q.total, 32400);
  });

  test('only the days offer applies', () {
    final q = quoteFor(demio, offer, 7);
    expect(q.subtotal, 24500);
    expect(q.discountPercent, 15);
    expect(q.total, 20825);
  });

  test('when both apply, the larger discount wins', () {
    final q = quoteFor(prado, offer, 7);
    expect(q.bothApply, isTrue);
    expect(q.discountPercent, 15);
    expect(q.discount, 12600);
    expect(q.total, 71400);
  });

  test('money is shown with commas', () {
    expect(money(71400), 'KSh 71,400');
    expect(money(500), 'KSh 500');
    expect(money(1200000), 'KSh 1,200,000');
  });
}
