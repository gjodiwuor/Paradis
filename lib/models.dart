import 'package:flutter/painting.dart';

import 'format.dart';
import 'pricing.dart';

/// The two discounts every company sets.
class Offer {
  const Offer({
    required this.minTotal,
    required this.totalPercent,
    required this.minDays,
    required this.daysPercent,
  });

  /// Percent off when the booking total is at least [minTotal] KSh.
  final int minTotal;
  final int totalPercent;

  /// Percent off when the hire lasts at least [minDays] days.
  final int minDays;
  final int daysPercent;
}

class Review {
  const Review(this.name, this.stars, this.comment);

  final String name;
  final int stars;
  final String comment;
}

class Vehicle {
  const Vehicle({
    required this.name,
    required this.category,
    required this.photo,
    this.photoAlign = Alignment.center,
    required this.seats,
    required this.transmission,
    required this.pricePerDay,
    required this.rating,
    required this.ratingCount,
    this.reviews = const [],
  });

  final String name;

  /// One of: Luxury, Off-road, Daily use, Trucks.
  final String category;
  final String photo;

  /// Which part of the photo to keep when it is cropped.
  final Alignment photoAlign;
  final int seats;
  final String transmission;
  final int pricePerDay;
  final double rating;
  final int ratingCount;
  final List<Review> reviews;
}

class Company {
  const Company({
    required this.name,
    required this.area,
    required this.photo,
    this.photoAlign = Alignment.center,
    required this.rating,
    required this.offer,
    required this.vehicles,
  });

  final String name;
  final String area;
  final String photo;
  final Alignment photoAlign;
  final double rating;
  final Offer offer;
  final List<Vehicle> vehicles;
}

class UserProfile {
  const UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    this.address = '',
    this.photo,
  });

  final String name;
  final String email;
  final String phone;

  /// Offered as the pickup location when booking. Empty means none saved.
  final String address;

  /// An asset path, or a file path picked from the gallery. Null shows initials.
  final String? photo;

  String get firstName => name.trim().split(' ').first;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? photo,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      photo: photo ?? this.photo,
    );
  }
}

class Booking {
  Booking({
    required this.id,
    required this.company,
    required this.vehicle,
    required this.pickup,
    required this.returnDate,
    required this.location,
    this.stars,
    this.comment,
  });

  final String id;
  final Company company;
  final Vehicle vehicle;
  final DateTime pickup;
  final DateTime returnDate;

  /// Where the car is picked up, and also where it is returned.
  final String location;

  /// Set once a finished trip is rated.
  int? stars;
  String? comment;

  int get days {
    final d = daysBetween(pickup, returnDate);
    return d < 1 ? 1 : d;
  }

  Quote get quote => quoteFor(vehicle, company.offer, days);

  bool get isPast => daysBetween(today(), returnDate) < 0;

  bool get isRated => stars != null;
}
