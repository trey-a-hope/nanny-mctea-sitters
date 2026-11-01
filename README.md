# Nanny McTea Sitters

The client mobile app for Nanny McTea Sitters, a babysitting business. Parents can browse the sitters, book a sitter for a date and time, pay by card, manage their appointments and message the business. It's a Flutter app from 2020 that uses Firebase for accounts and data, SuperSaaS for scheduling and Stripe for payments, with Firebase Cloud Functions in between.

## Features

- **Home**: the services offered, Meet the Team (sitter profiles), reviews and social media links (`lib/blocs/home/`).
- **Book a sitter**: a multi-step flow to choose a service, pick an open slot on a calendar, enter details and pay (`lib/blocs/bookSitterService/`, `bookSitterCalendar/`, `bookSitterInfo/`, `bookSitterPayment/`).
- **Appointments**: upcoming and past bookings with a details view (`lib/blocs/appointments/`, `appointmentDetails/`).
- **Payments**: saved cards, adding a card, payment history and a membership subscription with Gold and Silver plans (`lib/blocs/paymentMethod/`, `addCard/`, `paymentHistory/`, `subscription/`).
- **Messages**: in-app conversations with the business (`lib/blocs/messages/`, `conversation/`, using `dash_chat`).
- **Profile**: sign up, log in, edit your profile and photo, plus a contact page (`lib/blocs/signUp/`, `login/`, `profile/`, `editProfile/`, `contact/`).
- Push notifications through Firebase Cloud Messaging.

## How it works

Each screen is a folder in `lib/blocs/` with its page, Bloc, events and states (`flutter_bloc`), and services are registered with `get_it` in `lib/ServiceLocator.dart`.

- **Firebase** (`lib/services/AuthService.dart`, `DBService.dart`, `StorageService.dart`, `ConversationService.dart`, `MessageService.dart`): Auth, Firestore for users and conversations, Storage for photos.
- **Scheduling** (`lib/services/supersaas/`): open slots, new appointments and agendas come from SuperSaaS through Cloud Functions such as `GetAvailableAppointments`, `CreateAppointment` and `GetAgenda`.
- **Payments** (`lib/services/stripe/`): customers, cards, tokens, charges, orders, SKUs, coupons, plans and subscriptions, also through Cloud Functions.
- The Cloud Functions base URL, the SuperSaaS schedule ID, admin user IDs and the Stripe plan price IDs are in `lib/constants.dart`. The Cloud Functions code isn't in this repo.

```
lib/
├── main.dart, ServiceLocator.dart, constants.dart, themeData.dart
├── blocs/      # one folder per screen
├── common/     # shared widgets (calendar, nav drawer, sitter cards, clippers)
├── models/     # database, firebase, local, stripe, supersaas
├── pages/      # services, settings, messages, plans & pricing
└── services/   # Firebase, SuperSaaS and Stripe services
```

## Tech stack

- Flutter, Dart SDK `>=2.6.0 <3.0.0` (pre-null-safety)
- `flutter_bloc` 4, `get_it`, `equatable`
- Firebase: Auth, Cloud Firestore, Storage, Messaging, Cloud Functions
- SuperSaaS (scheduling) and Stripe (payments)
- `table_calendar`, `device_calendar`, `flutter_credit_card`, `awesome_card`, `dash_chat`, `intro_views_flutter`

## Getting started

1. Use a Flutter SDK that supports Dart 2.x. The project predates null safety, so current Flutter won't build it without migration.
2. Firebase config files for the `nanny-mctea-sitters` project are committed (`android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist`).
3. Install and run:

```sh
flutter pub get
flutter run
```

## Security note

`lib/constants.dart` has Stripe secret keys in comments (including a live key), and `lib/services/FCMNotificationService.dart` has a Firebase Cloud Messaging server key. They should be revoked and removed from the code.
