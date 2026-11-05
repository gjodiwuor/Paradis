# Paradis: handoff notes

Written on 5 November 2026 so another assistant, such as Cursor, can pick up the work.
It covers what the project is, everything decided so far, how the code is laid
out, what has been checked, and what is left.

## 1. The project

- **Course:** APT3060 Mobile Programming, group project.
- **App:** Paradis, a car-hire app. A customer picks a car-hire company, then
  books one of that company's vehicles.
- **Scope:** a prototype that imitates a real app. It does not need to really
  work: there is no server, login check, payment or database. Sample data is
  kept in memory while the app is open.
- **Tech:** Flutter with Dart, for both Android and iOS from one codebase.
  The student wants to open and run it in **Android Studio**. Do not switch to
  Java or Kotlin.
- **Repo:** https://github.com/gjodiwuor/Paradis (public), branch `main`.
  The repo root is this folder, `GRP Project`.
- **Brief:** `Paradis.pdf` in this folder, the group's draft.

## 2. What the brief asks for (Paradis.pdf)

Bottom tabs: Home, Bookings, Profile.

| # | Screen | Contents |
|---|---|---|
| 1 | Sign in | Email and password. New customers sign up with name, email, phone, password. |
| 2 | Home | Car-hire companies: area, number of vehicles, rating as stars. |
| 3 | Company | Only that company's vehicles. Filters: All, Luxury, Off-road, Daily use, Trucks. Shows its discounts and each vehicle's stars. |
| 4 | Vehicle | Category, seats, transmission, price per day, rating, recent reviews. |
| 5 | Book | Dates, price, any discount, amount to pay. With a saved address the customer can use it or enter another pickup location; without one they must enter a location. A line says the car is returned there too. |
| 6 | Bookings | Upcoming and past trips. A completed trip is rated by tapping stars. |
| 7 | Profile | Name, email, phone, address, sign out. The address is the one offered during booking. |

Rules:
- **Discounts:** each company sets two offers: a percent off when the booking
  total reaches a set amount, and a percent off when the hire lasts a set number
  of days. If both apply, only the larger discount is used.
- **Ratings:** a finished trip is rated with stars and a comment. Reviews are
  listed under the score, each with its stars and comment.

Gaps in the brief, filled with these defaults (all built):
- Create account is its own screen.
- Booking confirmed screen after booking (no payment step).
- Rate a trip is a bottom sheet with stars and a comment.
- Edit profile screen, so an address and photo can be added.

## 3. How we got here

1. Read the PDF and the class folder. Earlier class work was native Android in
   Java (`FoodOrderingApp`, `MainActivityApp`) plus one Dart exercise.
2. Built a design canvas (Claude Design artifact) with an app map, a rules board,
   and the screens.
3. First design used the PDF's look (navy, blue, Helvetica). The student found
   it too plain.
4. Researched car-rental app designs (Dribbble, design write-ups) and redesigned
   around large real photos, rounded cards and a floating bottom bar.
5. Many rounds of feedback (section 4), then built the Flutter app from the
   final designs and pushed it to GitHub.

The canvas is private to the student's Claude account:
https://claude.ai/artifact/N4t93a3qwjS68S4LivpqKC
It has a "Screens" page with one artboard per screen. The Flutter screens were
built to match it. If you can't open it, use this document and the code.

## 4. Design decisions the student made (keep these)

These came from direct feedback. Don't undo them without asking.

**Overall look**
- Light background `#F3F5FA`, dark ink text `#0E1B33`, font Plus Jakarta Sans.
- **No navy banner at the top of screens.** Screens start on the light
  background with dark text, or with a full photo.
- **Buttons are black** (`#1C1C1E`), radius 18, height 56, white label, with a
  small round arrow on the right. Secondary buttons are white with a thin border.
  The blue buttons from earlier rounds were rejected.
- **Bottom bar:** a black pill (`#1C1C1E`, fully rounded). The open tab is a
  lighter grey pill (`#3A3A3C`) with its icon and name. The other tabs show only
  an icon. This was modelled on a reference image the student supplied.
- Blue (`#336BDB`, `#2456BE`) is still used for small accents: links, the
  selected pickup option, tags, icons, the booking-confirmed tick.
- Amber stars (`#F5A524`).

**Logo**
- The Wings of Freedom from Attack on Titan, supplied by the student.
  `assets/logo/wings_of_freedom_transparent.png` is the version with its grey
  square removed. It's fine for a class project, but shouldn't be published in an app store.

**Photos**
- Real photos only. Car photos come from Wikimedia Commons (credits in
  `assets/photos/CREDITS.md`). Two photos were supplied by the student:
  `create_account.jpg` (man holding car keys) and `profile.jpg` (profile picture).
- **Number plates must be Kenyan, or hidden.** Format `KXY 123Z`. The first
  two letters are K plus A, B, C or D. When the second letter is A, B or C, the
  third letter can be A to Z. When it is D, the third letter can only be A to O.
  Examples used: KDG 412C, KCU 738M, KBZ 215Q, KCJ 642F, KDL 317B, KDC 905T,
  KAY 759G. Foreign plates were painted over or blurred in the photos.
- Sign in uses a driver's view through the windscreen (`road.jpg`).
- The student rejected earlier portrait photos. Use the supplied `profile.jpg`.

**Per screen**
- Home: no initials avatar in the header. Logo and PARADIS, a greeting, then
  large photo cards for each company.
- Company: tall photo with the name and rating, then a light sheet with
  **curved top corners** that overlaps the photo (like Vehicle). The student
  said it looked "congested" before, so keep the generous spacing. Filter chips
  must stay fully rounded. The back button sits 12px higher than on other screens,
  as the student asked.
- Vehicle: large photo, white sheet with curved top, spec tiles, a dark rating
  card, reviews that scroll sideways, and a bottom bar with the price and "Book this car".
- Booking confirmed: a **faded photo behind the whole page** (Nyali beach at
  50% opacity, nothing else over it), a ticket-style card, and two buttons.
- Profile: a centred photo with a small pen badge, Edit profile button, details
  card, and **Sign out pinned at the bottom** above the tab bar.
- Edit profile: the photo is **centred**. Tap the photo to change it; a shaded
  strip with a pen across its bottom shows that.

**Prices** (KSh per day, checked against Nairobi car-hire listings)
Mazda Demio 3,500 · Toyota Axio 5,000 · Toyota Land Cruiser Prado 12,000 ·
Toyota Hilux 13,000 · Mercedes E-Class 18,000 · BMW 5 Series 20,000 ·
Isuzu NQR 14,000 · Mitsubishi Canter 10,000. Discount thresholds and company
names are made up. Real rates usually add 16% VAT, which the app doesn't show.

## 5. How the code is laid out

```
lib/
  main.dart            Starts the app on the Sign in screen
  theme.dart           AppColors and the theme (Plus Jakarta Sans via google_fonts)
  models.dart          Offer, Review, Vehicle, Company, UserProfile, Booking
  data.dart            Sample cars, 6 companies, the sample customer and 3 trips
  pricing.dart         quoteFor(): price, discount (larger of two offers), total
  format.dart          money(), shortDate(), dayMonth(), today(), addDays(), daysBetween()
  app_state.dart       AppState (ChangeNotifier) and the global `appState`
  screens/             One file per screen (see README.md for the list)
  widgets/
    buttons.dart       PrimaryButton (black), SecondaryButton, RoundBackButton
    nav_bar.dart       The black pill bottom bar
    app_text_field.dart
    stars.dart
    avatar.dart        Photo from an asset or a picked file, or initials
    common.dart        LogoTitle, PhotoWithShade, WhiteCard, DashedLine, LabelValue
assets/photos/         Photos and CREDITS.md
assets/logo/           Logo files
test/pricing_test.dart Discount rule tests
```

How it works:
- **State:** one global `appState` (a `ChangeNotifier` in `app_state.dart`).
  Screens rebuild with `ListenableBuilder(listenable: appState, ...)`.
  `appState.tab` is a `ValueNotifier<int>` for the open bottom tab.
- **Navigation:** plain `Navigator.push` with `MaterialPageRoute`. `MainShell`
  holds the three tabs in an `IndexedStack` with the bottom bar.
- **Sign in:** any details sign in as the sample customer, Amina, with a saved
  address and three trips. Create account starts a new customer with no address,
  no photo and no trips, which shows the "must enter a location" state on Book.
- **Book:** the dates open `showDateRangePicker`. The price updates live from
  `quoteFor()`. Confirming adds the trip and opens Booking confirmed.
- **Ratings:** tapping a star on a past trip opens `rate_trip_sheet.dart`.
- **Edit profile:** the photo uses `image_picker` (gallery). The iOS Info.plist
  has `NSPhotoLibraryUsageDescription`.
- **Packages:** `google_fonts` (downloads the font on first run, so the Android
  manifest has the INTERNET permission) and `image_picker`.
- Each company's vehicle count shows how many cars it actually lists.

## 6. What has been checked

| Check | Result |
|---|---|
| `flutter analyze` | No issues |
| `flutter test` | 5 of 5 pass (discount rules, money format) |
| `flutter build ios --simulator --debug` | Builds |
| `flutter build apk --debug` | **Failed**, but not because of the app code. The Android NDK at `~/Library/Android/sdk/ndk/28.2.13676358` is an incomplete download with no `source.properties` file. See section 7. |
| Running the app and tapping through the screens | **Not done** on any device or emulator |
| Comparing the running app with the canvas | **Not done** |

Flutter 3.44.5, Dart 3.12.2, Xcode 26.6 and Android Studio are installed on the
student's Mac.

## 7. Where things stand

- Pushed to `main`: the app ("Build the Paradis car-hire app in Flutter"),
  then the Android Studio steps in `README.md` together with this file.
- The student still has to do two things before Android works in Android Studio:
  1. Install the **Flutter** plugin (Settings › Plugins › Marketplace). It
     wasn't installed.
  2. Accept the Android SDK licences: `flutter doctor --android-licenses`.
     This is a legal agreement, so the student must accept it themselves.
- After that, fix the broken NDK: delete
  `~/Library/Android/sdk/ndk/28.2.13676358` and build again. The Android
  Gradle Plugin then downloads a fresh copy. Flutter's own error message
  suggests this fix. The student has agreed to this, but only once the licences are accepted.
- Status on 5 November 2026: `flutter doctor` still says "Some Android licenses
  not accepted". The `28.2.13676358` folder is an empty 4 KB stub (only an
  `.installer` folder) left behind by the failed download, so deleting it is safe.
  A complete NDK `27.0.12077973` is also installed.

## 8. Next steps

1. Get the Android build working: accept the licences, fix the NDK (section 7),
   then run `flutter build apk --debug`. The iOS build already works.
2. Run on an Android emulator and the iOS Simulator. Tap through every screen and fix any
   overflow or layout problems. The ones most likely to need a look are Company
   (curved sheet and grid), Book with the keyboard open, and the rating sheet.
3. Compare each screen with the canvas, and keep the decisions in section 4.
4. Optional, only if the student asks:
   - set the app icon to the logo (for example with `flutter_launcher_icons`)
   - save data between launches (the course covered Firebase Realtime Database)
   - remove the unused photos `acacia.jpg` and `prado_white.jpg`

## 9. How the student likes to work

- Keep the code simple and easy to find your way around.
- Ask before adding features that aren't in the brief.
- Make targeted changes when asked. Don't redesign other parts.
- Use real photos, not placeholders or drawings.
- Explain what changed in plain words.
- Push to `gjodiwuor/Paradis` only when the student asks.
- End commit messages with a `Co-Authored-By` line naming the assistant that
  made the change.
