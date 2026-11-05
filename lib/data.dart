import 'package:flutter/painting.dart';

import 'format.dart';
import 'models.dart';

// Sample data. Nothing here comes from a server: the app is a prototype.
// Prices are realistic for Nairobi car hire; companies, people and plates are made up.

const prado = Vehicle(
  name: 'Toyota Land Cruiser Prado',
  category: 'Off-road',
  photo: 'assets/photos/prado.jpg',
  photoAlign: Alignment(0.5, 0.1),
  seats: 7,
  transmission: 'Automatic',
  pricePerDay: 12000,
  rating: 4.7,
  ratingCount: 128,
  reviews: [
    Review('Brian', 5, 'Clean car, picked up on time.'),
    Review('Wanjiru', 5, 'Smooth drive all the way to Naivasha.'),
    Review('Otieno', 4, 'Good value, pickup ran a little late.'),
  ],
);

const eClass = Vehicle(
  name: 'Mercedes-Benz E-Class',
  category: 'Luxury',
  photo: 'assets/photos/eclass.jpg',
  photoAlign: Alignment(0, 0.2),
  seats: 5,
  transmission: 'Automatic',
  pricePerDay: 18000,
  rating: 4.9,
  ratingCount: 64,
  reviews: [
    Review('Achieng', 5, 'Felt like a VIP at the wedding.'),
    Review('Kamau', 5, 'Spotless inside and very quiet.'),
  ],
);

const demio = Vehicle(
  name: 'Mazda Demio',
  category: 'Daily use',
  photo: 'assets/photos/demio.jpg',
  photoAlign: Alignment(0.5, 0.2),
  seats: 5,
  transmission: 'Automatic',
  pricePerDay: 3500,
  rating: 4.6,
  ratingCount: 211,
  reviews: [
    Review('Njeri', 5, 'Easy to park around town.'),
    Review('Mutua', 4, 'Light on fuel, a bit small for luggage.'),
  ],
);

const hilux = Vehicle(
  name: 'Toyota Hilux Double Cab',
  category: 'Off-road',
  photo: 'assets/photos/hilux.jpg',
  photoAlign: Alignment(-0.6, 0.1),
  seats: 5,
  transmission: 'Manual',
  pricePerDay: 13000,
  rating: 4.4,
  ratingCount: 87,
  reviews: [
    Review('Kiprop', 4, 'Handled the murram road well.'),
    Review('Akinyi', 5, 'Plenty of space for our gear.'),
  ],
);

const axio = Vehicle(
  name: 'Toyota Axio',
  category: 'Daily use',
  photo: 'assets/photos/axio.jpg',
  photoAlign: Alignment(0, 0.2),
  seats: 5,
  transmission: 'Automatic',
  pricePerDay: 5000,
  rating: 4.4,
  ratingCount: 154,
  reviews: [
    Review('Wafula', 4, 'Comfortable for a long drive.'),
    Review('Chebet', 4, 'Good value for daily errands.'),
  ],
);

const nqr = Vehicle(
  name: 'Isuzu NQR',
  category: 'Trucks',
  photo: 'assets/photos/nqr.jpg',
  photoAlign: Alignment(0, 0.1),
  seats: 3,
  transmission: 'Manual',
  pricePerDay: 14000,
  rating: 4.3,
  ratingCount: 39,
  reviews: [
    Review('Omondi', 4, 'Moved our whole house in one trip.'),
    Review('Moraa', 4, 'Clean cab and easy to drive.'),
  ],
);

const bmw5 = Vehicle(
  name: 'BMW 5 Series',
  category: 'Luxury',
  photo: 'assets/photos/bmw5.jpg',
  photoAlign: Alignment(0.7, 0.2),
  seats: 5,
  transmission: 'Automatic',
  pricePerDay: 20000,
  rating: 4.7,
  ratingCount: 52,
  reviews: [
    Review('Kariuki', 5, 'Smooth and powerful.'),
    Review('Zawadi', 4, 'Great car, but heavy on fuel.'),
  ],
);

const canter = Vehicle(
  name: 'Mitsubishi Canter',
  category: 'Trucks',
  photo: 'assets/photos/canter.jpg',
  photoAlign: Alignment(-0.3, 0.1),
  seats: 3,
  transmission: 'Manual',
  pricePerDay: 10000,
  rating: 4.2,
  ratingCount: 45,
  reviews: [
    Review('Juma', 4, 'Reliable for our deliveries.'),
    Review('Nduta', 4, 'Easy to drive for its size.'),
  ],
);

const categories = ['All', 'Luxury', 'Off-road', 'Daily use', 'Trucks'];

const companies = [
  Company(
    name: 'Savanna Drive',
    area: 'Westlands',
    photo: 'assets/photos/savanna_wide.jpg',
    photoAlign: Alignment(0.44, 0.24),
    rating: 4.7,
    offer: Offer(minTotal: 30000, totalPercent: 10, minDays: 7, daysPercent: 15),
    vehicles: [prado, eClass, demio, hilux, axio, nqr, bmw5, canter],
  ),
  Company(
    name: 'Kilima Car Hire',
    area: 'Kilimani',
    photo: 'assets/photos/axio.jpg',
    photoAlign: Alignment(0, 0.24),
    rating: 4.4,
    offer: Offer(minTotal: 15000, totalPercent: 5, minDays: 5, daysPercent: 10),
    vehicles: [demio, axio, hilux, canter],
  ),
  Company(
    name: 'Rift Road Rentals',
    area: 'Karen',
    photo: 'assets/photos/safari_green.jpg',
    photoAlign: Alignment(0, 0.1),
    rating: 4.8,
    offer: Offer(minTotal: 40000, totalPercent: 10, minDays: 7, daysPercent: 12),
    vehicles: [prado, hilux, eClass, axio],
  ),
  Company(
    name: 'Pwani Wheels',
    area: 'Nyali, Mombasa',
    photo: 'assets/photos/nyali_beach.jpg',
    photoAlign: Alignment(0, -0.1),
    rating: 4.2,
    offer: Offer(minTotal: 20000, totalPercent: 8, minDays: 4, daysPercent: 10),
    vehicles: [demio, axio, prado, nqr],
  ),
  Company(
    name: 'Jiji Motors',
    area: 'Mombasa Road',
    photo: 'assets/photos/bmw5.jpg',
    photoAlign: Alignment(0, 0.2),
    rating: 4.4,
    offer: Offer(minTotal: 50000, totalPercent: 10, minDays: 10, daysPercent: 15),
    vehicles: [bmw5, eClass, axio, canter, nqr],
  ),
  Company(
    name: 'Mlima Safari Cars',
    area: 'Nanyuki',
    photo: 'assets/photos/safari_yellow.jpg',
    photoAlign: Alignment(0, 0.1),
    rating: 4.9,
    offer: Offer(minTotal: 30000, totalPercent: 10, minDays: 7, daysPercent: 20),
    vehicles: [prado, hilux, demio],
  ),
];

const sampleUser = UserProfile(
  name: 'Amina Wanjiku',
  email: 'amina@example.com',
  phone: '+254 700 000 000',
  address: 'Argwings Kodhek Road, Kilimani',
  photo: 'assets/photos/profile.jpg',
);

/// Three trips for the sample user, with dates counted from today.
List<Booking> sampleBookings() {
  final now = today();
  return [
    Booking(
      id: 'b1',
      company: companies[0],
      vehicle: prado,
      pickup: addDays(now, 8),
      returnDate: addDays(now, 15),
      location: sampleUser.address,
    ),
    Booking(
      id: 'b2',
      company: companies[1],
      vehicle: demio,
      pickup: addDays(now, -22),
      returnDate: addDays(now, -19),
      location: sampleUser.address,
    ),
    Booking(
      id: 'b3',
      company: companies[0],
      vehicle: axio,
      pickup: addDays(now, -61),
      returnDate: addDays(now, -58),
      location: sampleUser.address,
      stars: 4,
      comment: 'Easy pickup and good on fuel.',
    ),
  ];
}
