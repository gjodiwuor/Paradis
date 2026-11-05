import 'package:flutter/foundation.dart';

import 'data.dart';
import 'models.dart';

/// Everything the app remembers while it is open: who is signed in,
/// their bookings, and which bottom tab is showing.
///
/// Screens read it through [appState] and rebuild with a ListenableBuilder.
class AppState extends ChangeNotifier {
  UserProfile user = sampleUser;
  List<Booking> bookings = sampleBookings();

  /// 0 = Home, 1 = Bookings, 2 = Profile.
  final tab = ValueNotifier<int>(0);

  int _nextId = 100;

  List<Booking> get upcoming =>
      bookings.where((b) => !b.isPast).toList()
        ..sort((a, b) => a.pickup.compareTo(b.pickup));

  List<Booking> get past =>
      bookings.where((b) => b.isPast).toList()
        ..sort((a, b) => b.pickup.compareTo(a.pickup));

  /// Signs in as the sample customer. Any email typed in is kept.
  void signIn(String email) {
    final typed = email.trim();
    user = typed.isEmpty ? sampleUser : sampleUser.copyWith(email: typed);
    bookings = sampleBookings();
    tab.value = 0;
    notifyListeners();
  }

  /// A new customer starts with no address, no photo and no trips.
  void createAccount({
    required String name,
    required String email,
    required String phone,
  }) {
    user = UserProfile(
      name: name.trim().isEmpty ? 'New customer' : name.trim(),
      email: email.trim(),
      phone: phone.trim(),
    );
    bookings = [];
    tab.value = 0;
    notifyListeners();
  }

  void signOut() {
    tab.value = 0;
  }

  void updateProfile(UserProfile updated) {
    user = updated;
    notifyListeners();
  }

  Booking addBooking({
    required Company company,
    required Vehicle vehicle,
    required DateTime pickup,
    required DateTime returnDate,
    required String location,
  }) {
    final booking = Booking(
      id: 'b${_nextId++}',
      company: company,
      vehicle: vehicle,
      pickup: pickup,
      returnDate: returnDate,
      location: location,
    );
    bookings.add(booking);
    notifyListeners();
    return booking;
  }

  void rateBooking(Booking booking, int stars, String comment) {
    booking.stars = stars;
    booking.comment = comment.trim();
    notifyListeners();
  }
}

final appState = AppState();
