# Jerbi App

Flutter admin app for managing event reservations (Jerbi Events).

Features: admin login, reservations (list, search, filter, add, edit, delete), statistics, admin permission management, settings. See the [root README](../README.md) for details and what is not finished yet.

## Run

Requires the [Flutter SDK](https://docs.flutter.dev/get-started/install) and the backend in [`../backend`](../backend) running on port 5000.

```bash
flutter pub get
flutter run
```

The API base URLs are hardcoded (`localhost:5000`, or `10.0.2.2:5000` on the Android emulator) in the files under `lib/features/` and `lib/shared/services/admin_service.dart` that call the API; change them to point at your own server.
