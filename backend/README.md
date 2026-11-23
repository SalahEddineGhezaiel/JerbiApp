# Jerbi Events Backend API

## Setup Instructions

### 1. Environment Configuration
Copy `.env.example` to `.env` and fill in your MongoDB Atlas credentials and a long random `JWT_SECRET`. Never commit `.env`.

### 2. Install Dependencies
```bash
npm install
```

### 3. Create Admin User
```bash
ADMIN_PASSWORD='choose-a-strong-password' npm run create-admin
```

### 4. Start Server
```bash
# Development mode (with auto-restart)
npm run dev

# Production mode
npm start
```

## API Endpoints

### Authentication

#### POST /api/auth/login
Login with admin credentials

**Request:**
```json
{
  "username": "admin",
  "password": "your-admin-password"
}
```

**Response (Success):**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "admin": {
      "id": "admin_id",
      "username": "admin",
      "email": "admin@jerbi-events.com",
      "role": "super-admin",
      "lastLogin": "2024-01-01T00:00:00.000Z"
    },
    "token": "jwt_token_here",
    "expiresIn": "24h"
  },
  "timestamp": "2024-01-01T00:00:00.000Z"
}
```

#### GET /api/auth/verify
Verify JWT token (requires Authorization header)

**Headers:**
```
Authorization: Bearer your_jwt_token_here
```

**Response:**
```json
{
  "success": true,
  "message": "Token is valid",
  "data": {
    "admin": {
      "id": "admin_id",
      "username": "admin",
      "email": "admin@jerbi-events.com",
      "role": "super-admin"
    }
  }
}
```

#### POST /api/auth/logout
Logout (client should remove token)

**Headers:**
```
Authorization: Bearer your_jwt_token_here
```

### Admin Management

#### GET /api/admin/profile
Get current admin profile with permissions

**Headers:**
```
Authorization: Bearer your_jwt_token_here
```

**Response:**
```json
{
  "success": true,
  "message": "Admin profile retrieved successfully",
  "data": {
    "admin": {
      "id": "admin_id",
      "username": "admin",
      "email": "admin@jerbi-events.com",
      "role": "super-admin",
      "permissions": {
        "canCreateAdmins": true,
        "canDeleteAdmins": true,
        "canViewReservations": true,
        "canCreateReservations": true,
        "canEditReservations": true,
        "canDeleteReservations": true,
        "canViewStatistics": true,
        "canManageSettings": true
      },
      "isActive": true,
      "lastLogin": "2024-01-01T00:00:00.000Z",
      "createdAt": "2024-01-01T00:00:00.000Z"
    }
  }
}
```

#### GET /api/admin/list
Get all admins (requires canCreateAdmins permission or super-admin)

**Headers:**
```
Authorization: Bearer your_jwt_token_here
```

#### POST /api/admin/create
Create new admin (requires canCreateAdmins permission or super-admin)

**Headers:**
```
Authorization: Bearer your_jwt_token_here
Content-Type: application/json
```

**Request:**
```json
{
  "username": "staff1",
  "email": "staff1@jerbi-events.com",
  "password": "StaffPass123",
  "permissions": {
    "canCreateAdmins": false,
    "canDeleteAdmins": false,
    "canViewReservations": true,
    "canCreateReservations": true,
    "canEditReservations": true,
    "canDeleteReservations": false,
    "canViewStatistics": true,
    "canManageSettings": false
  }
}
```

#### PUT /api/admin/:id/permissions
Update admin permissions (requires canCreateAdmins permission or super-admin)

**Headers:**
```
Authorization: Bearer your_jwt_token_here
Content-Type: application/json
```

**Request:**
```json
{
  "permissions": {
    "canCreateReservations": false,
    "canEditReservations": false
  }
}
```

#### PUT /api/admin/:id/deactivate
Deactivate admin (requires canDeleteAdmins permission or super-admin)

**Headers:**
```
Authorization: Bearer your_jwt_token_here
```

#### PUT /api/admin/:id/activate
Activate admin (requires canCreateAdmins permission or super-admin)

**Headers:**
```
Authorization: Bearer your_jwt_token_here
```

### Health Check

#### GET /health
Check if API is running

**Response:**
```json
{
  "success": true,
  "message": "Jerbi Events API is running",
  "timestamp": "2024-01-01T00:00:00.000Z",
  "environment": "development"
}
```

## Postman Testing

### 1. Test Health Check
- **Method:** GET
- **URL:** `http://localhost:5000/health`

### 2. Test Login
- **Method:** POST
- **URL:** `http://localhost:5000/api/auth/login`
- **Headers:** `Content-Type: application/json`
- **Body (raw JSON):**
```json
{
  "username": "admin",
  "password": "your-admin-password"
}
```

### 3. Test Token Verification
- **Method:** GET
- **URL:** `http://localhost:5000/api/auth/verify`
- **Headers:** 
  - `Content-Type: application/json`
  - `Authorization: Bearer [paste_token_from_login_response]`

## Error Responses

All error responses follow this format:
```json
{
  "success": false,
  "message": "Error description",
  "errors": [], // Optional validation errors
  "timestamp": "2024-01-01T00:00:00.000Z"
}
```

## Project Structure

```
backend/
├── config/
│   └── database.js          # MongoDB connection
├── controllers/
│   ├── adminController.js         # Admin management logic
│   ├── authController.js          # Authentication logic
│   └── reservationController.js   # Reservation CRUD and statistics
├── middleware/
│   ├── auth.js                    # JWT middleware
│   └── reservationValidation.js   # Reservation request validation
├── models/
│   ├── Admin.js                   # Admin user model
│   └── Reservation.js             # Reservation model
├── routes/
│   ├── admin.js                   # Admin routes
│   ├── auth.js                    # Auth routes
│   └── reservations.js            # Reservation routes
├── scripts/
│   ├── createAdmin.js             # Create the super-admin
│   └── updateAdmin.js             # Reset the super-admin's permissions
├── utils/
│   └── response.js          # API response utilities
├── .env.example             # Environment variable template (copy to .env)
├── .gitignore              # Git ignore rules
├── package.json            # Dependencies
└── server.js               # Main server file
```