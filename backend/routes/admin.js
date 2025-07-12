const express = require('express');
const { body, param } = require('express-validator');
const {
  getAllAdmins,
  createAdmin,
  updateAdminPermissions,
  deactivateAdmin,
  activateAdmin,
  getAdminProfile
} = require('../controllers/adminController');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();

// All admin routes require authentication
router.use(authenticateToken);

/**
 * @route   GET /api/admin/profile
 * @desc    Get current admin profile with permissions
 * @access  Private
 */
router.get('/profile', getAdminProfile);

/**
 * @route   GET /api/admin/list
 * @desc    Get all admins (requires canCreateAdmins permission or super-admin)
 * @access  Private
 */
router.get('/list', getAllAdmins);

/**
 * @route   POST /api/admin/create
 * @desc    Create new admin (requires canCreateAdmins permission or super-admin)
 * @access  Private
 */
router.post('/create', [
  body('username')
    .notEmpty()
    .withMessage('Username is required')
    .trim()
    .isLength({ min: 3, max: 30 })
    .withMessage('Username must be between 3 and 30 characters')
    .matches(/^[a-zA-Z0-9_]+$/)
    .withMessage('Username can only contain letters, numbers, and underscores'),
  
  body('email')
    .isEmail()
    .withMessage('Please provide a valid email')
    .normalizeEmail(),
  
  body('password')
    .isLength({ min: 6, max: 50 })
    .withMessage('Password must be between 6 and 50 characters')
    .matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/)
    .withMessage('Password must contain at least one lowercase letter, one uppercase letter, and one number'),
  
  body('permissions')
    .optional()
    .isObject()
    .withMessage('Permissions must be an object'),
  
  body('permissions.canCreateAdmins')
    .optional()
    .isBoolean()
    .withMessage('canCreateAdmins must be a boolean'),
  
  body('permissions.canDeleteAdmins')
    .optional()
    .isBoolean()
    .withMessage('canDeleteAdmins must be a boolean'),
  
  body('permissions.canViewReservations')
    .optional()
    .isBoolean()
    .withMessage('canViewReservations must be a boolean'),
  
  body('permissions.canCreateReservations')
    .optional()
    .isBoolean()
    .withMessage('canCreateReservations must be a boolean'),
  
  body('permissions.canEditReservations')
    .optional()
    .isBoolean()
    .withMessage('canEditReservations must be a boolean'),
  
  body('permissions.canDeleteReservations')
    .optional()
    .isBoolean()
    .withMessage('canDeleteReservations must be a boolean'),
  
  body('permissions.canViewStatistics')
    .optional()
    .isBoolean()
    .withMessage('canViewStatistics must be a boolean'),
  
  body('permissions.canManageSettings')
    .optional()
    .isBoolean()
    .withMessage('canManageSettings must be a boolean')
], createAdmin);

/**
 * @route   PUT /api/admin/:id/permissions
 * @desc    Update admin permissions (requires canCreateAdmins permission or super-admin)
 * @access  Private
 */
router.put('/:id/permissions', [
  param('id')
    .isMongoId()
    .withMessage('Invalid admin ID'),
  
  body('permissions')
    .isObject()
    .withMessage('Permissions must be an object'),
  
  body('permissions.canCreateAdmins')
    .optional()
    .isBoolean()
    .withMessage('canCreateAdmins must be a boolean'),
  
  body('permissions.canDeleteAdmins')
    .optional()
    .isBoolean()
    .withMessage('canDeleteAdmins must be a boolean'),
  
  body('permissions.canViewReservations')
    .optional()
    .isBoolean()
    .withMessage('canViewReservations must be a boolean'),
  
  body('permissions.canCreateReservations')
    .optional()
    .isBoolean()
    .withMessage('canCreateReservations must be a boolean'),
  
  body('permissions.canEditReservations')
    .optional()
    .isBoolean()
    .withMessage('canEditReservations must be a boolean'),
  
  body('permissions.canDeleteReservations')
    .optional()
    .isBoolean()
    .withMessage('canDeleteReservations must be a boolean'),
  
  body('permissions.canViewStatistics')
    .optional()
    .isBoolean()
    .withMessage('canViewStatistics must be a boolean'),
  
  body('permissions.canManageSettings')
    .optional()
    .isBoolean()
    .withMessage('canManageSettings must be a boolean')
], updateAdminPermissions);

/**
 * @route   PUT /api/admin/:id/deactivate
 * @desc    Deactivate admin (requires canDeleteAdmins permission or super-admin)
 * @access  Private
 */
router.put('/:id/deactivate', [
  param('id')
    .isMongoId()
    .withMessage('Invalid admin ID')
], deactivateAdmin);

/**
 * @route   PUT /api/admin/:id/activate
 * @desc    Activate admin (requires canCreateAdmins permission or super-admin)
 * @access  Private
 */
router.put('/:id/activate', [
  param('id')
    .isMongoId()
    .withMessage('Invalid admin ID')
], activateAdmin);

module.exports = router;