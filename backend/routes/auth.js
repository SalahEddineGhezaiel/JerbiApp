const express = require('express');
const { body } = require('express-validator');
const { login, verifyToken } = require('../controllers/authController');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();

/**
 * @route   POST /api/auth/login
 * @desc    Admin login
 * @access  Public
 */
router.post('/login', [
  body('username')
    .notEmpty()
    .withMessage('Username or email is required')
    .trim()
    .isLength({ min: 3 })
    .withMessage('Username must be at least 3 characters long'),
  
  body('password')
    .notEmpty()
    .withMessage('Password is required')
    .isLength({ min: 6 })
    .withMessage('Password must be at least 6 characters long')
], login);

/**
 * @route   GET /api/auth/verify
 * @desc    Verify JWT token
 * @access  Private
 */
router.get('/verify', authenticateToken, verifyToken);

/**
 * @route   POST /api/auth/logout
 * @desc    Admin logout (client-side token removal)
 * @access  Private
 */
router.post('/logout', authenticateToken, (req, res) => {
  // Since JWT is stateless, logout is handled on client-side
  // This endpoint can be used for logging purposes
  res.json({
    success: true,
    message: 'Logged out successfully. Please remove token from client.'
  });
});

module.exports = router;