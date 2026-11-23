# Jerbi App

Admin app for Jerbi Events: staff log in to record, edit and track customer reservations for outdoor activities (kayak, boat trips, diving, camping), view reservation statistics, and manage other admins' permissions.

## Features

- **Login** with username or email; the API issues a JWT valid for 24 hours.
- **Reservations**: list, view details, add, edit and delete. Each reservation holds name, email, phone, adults, children by age group (under 4, 4-8, 9-12), date, activity, status (pending, confirmed, paid, cancelled) and notes.
- **Search and filters** on the reservation list: by name, email or phone, by date or date range, and by activity.
- **Statistics**: counts per status and a per-activity breakdown (reservations, adults, children), filterable by date range.
- **Admin management**: list all admins with their active/inactive state and edit each admin's permissions.
- **Permissions**: eight per-admin flags (create/delete admins, view/create/edit/delete reservations, view statistics, manage settings). The API enforces them for creating, editing and deleting reservations and for admin management; the app also checks them before add/edit/delete and before opening the Statistics tab.
- **Logout** from the Settings tab.

### Planned / not finished

- Charts on the Statistics tab: the chart area shows a "to implement" placeholder (`jerbi_app/lib/features/statistics/statistics_content.dart`); `fl_chart` is a dependency but not used yet.
- Data export and backup: the Settings tiles only show a placeholder message (`jerbi_app/lib/features/settings/settings_content.dart`).
- Creating, activating and deactivating admins from the app: the API endpoints exist, but the app only lists admins and edits permissions.
- Session persistence: the token is kept in memory (`jerbi_app/lib/shared/utils/token_manager.dart`), so restarting the app requires logging in again.
- Pagination in the app: it requests reservations without paging parameters, so it receives the API's default page of 10 (newest first), and search and filters run on those.
- Automated tests: `jerbi_app/test/widget_test.dart` is still the Flutter template test, and the backend has none.

## Tech stack

- **App**: Flutter (Dart SDK ^3.7.2), Material 3, `http` ^1.1.0, `fl_chart` ^0.68.0
- **API**: Node.js, Express ^4.21.2, Mongoose ^8.16.3 (MongoDB), `jsonwebtoken` ^9.0.2, `bcryptjs` ^3.0.2, `express-validator` ^7.2.1, `cors` ^2.8.5, `dotenv` ^17.2.0; `nodemon` ^3.1.10 for development

## Project structure

- [`jerbi_app/`](jerbi_app) - Flutter admin app (login, reservations, statistics, settings)
- [`backend/`](backend) - Express + MongoDB REST API used by the app

## API overview

All routes except login, activities and health require `Authorization: Bearer <token>`.

| Method | Path | Purpose |
|---|---|---|
| GET | `/health` | Check that the API is running |
| POST | `/api/auth/login` | Log in with username or email and password; returns a JWT |
| GET | `/api/auth/verify` | Check that a token is valid |
| POST | `/api/auth/logout` | Log out (the client discards the token) |
| GET | `/api/admin/profile` | Current admin with permissions |
| GET | `/api/admin/list` | List admins (needs `canCreateAdmins` or super-admin) |
| POST | `/api/admin/create` | Create an admin (needs `canCreateAdmins` or super-admin) |
| PUT | `/api/admin/:id/permissions` | Update an admin's permissions (needs `canCreateAdmins` or super-admin) |
| PUT | `/api/admin/:id/deactivate` | Deactivate an admin (needs `canDeleteAdmins` or super-admin) |
| PUT | `/api/admin/:id/activate` | Reactivate an admin (needs `canCreateAdmins` or super-admin) |
| GET | `/api/reservations` | List reservations; query: `page`, `limit` (default 10), `sortBy`, `sortOrder`, `status`, `activity`, `dateFrom`, `dateTo`, `search` |
| GET | `/api/reservations/stats` | Counts by status, per-activity totals, monthly counts for the last 12 months; query: `dateFrom`, `dateTo` |
| GET | `/api/reservations/activities` | List of bookable activities (public) |
| GET | `/api/reservations/:id` | One reservation |
| POST | `/api/reservations` | Create a reservation (needs `canCreateReservations`) |
| PUT | `/api/reservations/:id` | Update a reservation (needs `canEditReservations`) |
| DELETE | `/api/reservations/:id` | Delete a reservation (needs `canDeleteReservations`) |

See [`backend/README.md`](backend/README.md) for request and response examples.

## Getting started

### Backend

Requires Node.js and a MongoDB database (for example MongoDB Atlas).

```bash
cd backend
npm install
cp .env.example .env   # then fill in the values
```

Environment variables read by the code:

| Variable | Use |
|---|---|
| `MONGODB_URI` | MongoDB connection string (required) |
| `JWT_SECRET` | Secret used to sign tokens (required) |
| `PORT` | HTTP port, default `5000` |
| `CORS_ORIGIN` | Allowed origin, default `*` |
| `NODE_ENV` | Shown by `/health`; `development` adds stack traces to error responses |
| `ADMIN_PASSWORD` | Only for `npm run create-admin` |

Create the first super-admin (username `admin`), then start the server:

```bash
ADMIN_PASSWORD='choose-a-strong-password' npm run create-admin
npm run dev     # with auto-restart
npm start       # without
```

The API listens on `http://localhost:5000` by default.

### Flutter app

Requires the [Flutter SDK](https://docs.flutter.dev/get-started/install) and the backend running.

```bash
cd jerbi_app
flutter pub get
flutter run
```

The API base URL is hardcoded per platform (`http://localhost:5000` on web, desktop and the iOS simulator, `http://10.0.2.2:5000` on the Android emulator) in each file that calls the API: `lib/features/auth/login_page.dart`, `lib/features/reservations/reservations_content.dart`, `lib/features/settings/admin_management_page.dart`, `lib/features/statistics/services/statistics_service.dart` and `lib/shared/services/admin_service.dart`. Change it there to point at another server.

## Status

Login, reservation management, statistics counts and admin permission editing work end to end between the app and the API. Charts, data export and backup, admin creation from the app and persistent sessions are planned.
