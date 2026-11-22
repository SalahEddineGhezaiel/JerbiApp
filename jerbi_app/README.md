# Jerbi App

Flutter admin app for managing event reservations (Jerbi Events). **Work in progress.**

Features so far: admin login, reservations, admin management, settings.

## Run

Requires the [Flutter SDK](https://docs.flutter.dev/get-started/install) and the Jerbi backend (separate repo, `backend/`) running on `http://localhost:5000`.

```bash
flutter pub get
flutter run
```

The API base URLs are hardcoded to `localhost:5000` in `lib/features/*`; change them to point at your own server.
