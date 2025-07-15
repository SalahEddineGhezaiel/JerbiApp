const express = require('express');
const router = express.Router();

// Import controllers
const {
  getAllReservations,
  getReservationById,
  createReservation,
  updateReservation,
  deleteReservation,
  getReservationStats,
  getAvailableActivities
} = require('../controllers/reservationController');

// Import validation middleware
const {
  validateCreateReservation,
  validateUpdateReservation,
  validateGetReservation,
  validateDeleteReservation,
  validateReservationQuery
} = require('../middleware/reservationValidation');

// Import authentication middleware
const { authenticateToken } = require('../middleware/auth');

// Routes

// GET /api/reservations - Get all reservations with filtering and pagination
router.get('/', 
  authenticateToken, 
  validateReservationQuery, 
  getAllReservations
);

// GET /api/reservations/stats - Get reservation statistics
router.get('/stats', 
  authenticateToken, 
  getReservationStats
);

// GET /api/reservations/activities - Get available activities
router.get('/activities', 
  getAvailableActivities
);

// GET /api/reservations/:id - Get single reservation by ID
router.get('/:id', 
  authenticateToken, 
  validateGetReservation, 
  getReservationById
);

// POST /api/reservations - Create new reservation
router.post('/', 
  authenticateToken, 
  validateCreateReservation, 
  createReservation
);

// PUT /api/reservations/:id - Update reservation
router.put('/:id', 
  authenticateToken, 
  validateUpdateReservation, 
  updateReservation
);

// DELETE /api/reservations/:id - Delete reservation
router.delete('/:id', 
  authenticateToken, 
  validateDeleteReservation, 
  deleteReservation
);

module.exports = router;