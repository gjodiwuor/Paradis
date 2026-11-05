# Paradis

A car-hire app for the Mobile Programming group project. A customer picks a
car-hire company, then books one of that company's vehicles.

Built with Flutter (Dart). It is a prototype: there is no server, so the
companies, cars and bookings are sample data kept in memory while the app is open.

## Run it

```bash
flutter pub get
flutter run
```

Sign in with any email and password to use the sample customer, Amina.
Create account starts a new customer with no address and no trips.

## Where things are

```
lib/
  main.dart          Starts the app
  theme.dart         Colours and font
  models.dart        Company, Vehicle, Offer, Booking, UserProfile
  data.dart          Sample companies, cars, customer and trips
  pricing.dart       Works out the price and discount
  format.dart        Money and date helpers
  app_state.dart     Signed-in customer, bookings and the open tab
  screens/           One file per screen
  widgets/           Buttons, bottom bar, stars and other shared pieces
assets/
  photos/            Car and background photos (credits in CREDITS.md)
  logo/              The app logo
test/
  pricing_test.dart  Checks the discount rules
```

## Screens

| File | Screen |
|---|---|
| `sign_in_screen.dart` | Sign in |
| `create_account_screen.dart` | Create account |
| `main_shell.dart` | The bottom bar with Home, Bookings and Profile |
| `home_screen.dart` | Car-hire companies |
| `company_screen.dart` | One company's cars, offers and filters |
| `vehicle_screen.dart` | Car details and reviews |
| `book_screen.dart` | Dates, pickup location and price |
| `booking_confirmed_screen.dart` | The confirmed trip |
| `bookings_screen.dart` | Upcoming and past trips |
| `rate_trip_sheet.dart` | Rating a finished trip |
| `profile_screen.dart` | Profile and sign out |
| `edit_profile_screen.dart` | Edit details and photo |

## The rules

- Each company sets two offers: a percent off when the booking total reaches
  a set amount, and a percent off when the hire lasts a set number of days.
  If both apply, only the larger one is used.
- With a saved address, the customer can use it or enter another pickup
  location. Without one, they must enter a location. The car is returned
  to the same place.
- A finished trip is rated with stars and a comment.

## Notes

- Prices are realistic for Nairobi car hire. Company names, people and
  number plates are made up.
- The logo is the Wings of Freedom from Attack on Titan, used here for a class
  project only.
- Photo credits are in `assets/photos/CREDITS.md`. The Create account and
  profile photos were supplied by the group.
