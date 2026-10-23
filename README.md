# HomeServe Pro — Complete Flutter Home Services Marketplace Demo

A responsive Flutter application with three role-based experiences:

- **Customer:** discover services, choose a professional, schedule, repeat bookings, track jobs, messages, profile and booking history.
- **Worker:** dashboard, availability, incoming jobs, accept/start/complete workflow, earnings, profile and customer chat.
- **Admin / Business Owner:** marketplace overview, revenue/KPI cards, worker approvals, people management, booking management and service catalog.

## Run

```bash
flutter clean
flutter pub get
flutter run -d chrome
```

It intentionally uses **local in-memory demo data**, so the UI and workflows run without Firebase credentials or an API server.

## Production backend

For production, connect the repository/store layer to Firebase Authentication + Cloud Firestore (or your own API). Firebase Authentication and Firestore support Flutter/web/mobile and are appropriate for role-based identity/data flows. See the official Flutter/Firebase documentation before configuring credentials.

## UX goals

- Material 3 UI
- Responsive desktop/tablet/mobile layouts
- Animated route/page transitions
- Animated hero booking card
- Hero logo transition
- Booking confirmation animation
- Local fallback icons when service photos cannot load
- Scrollable content and Wrap-based chips to avoid common small-screen overflows

## Important

The app is a **fully interactive front-end/demo marketplace**. Real payments, SMS/OTP, push notifications, maps/GPS, background location, cloud persistence, worker identity verification, and production security rules require backend/platform credentials and configuration.
