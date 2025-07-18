const jwt = require('jsonwebtoken');
const { validationResult } = require('express-validator');
const Admin = require('../models/Admin');
const { sendSuccess, sendError, sendServerError, sendUnauthorized } = require('../utils/response');

/**
 * Generate JWT Token
 */
const generateToken = (adminId) => {
  return jwt.sign(
    { adminId, type: 'admin' },
    process.env.JWT_SECRET,
    { expiresIn: '24h' }
  );
};

/**
 * Admin Login
 * POST /api/auth/login
 */
const login = async (req, res) => {
  try {
    // Check for validation errors
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return sendError(res, 'Validation failed', errors.array(), 422);
    }

    const { username, password } = req.body;

    // Find admin by username or email
    const admin = await Admin.findOne({
      $or: [
        { username: username },
        { email: username }
      ],
      isActive: true
    });

    if (!admin) {
      return sendUnauthorized(res, 'Invalid credentials');
    }

    // Check password
    const isPasswordValid = await admin.comparePassword(password);
    if (!isPasswordValid) {
      return sendUnauthorized(res, 'Invalid credentials');
    }

    // Update last login
    admin.lastLogin = new Date();
    await admin.save();

    // Generate token
    const token = generateToken(admin._id);

    // Send response with full admin data including permissions
    return sendSuccess(res, 'Login successful', {
      admin: {
        id: admin._id,
        username: admin.username,
        email: admin.email,
        role: admin.role,
        permissions: admin.permissions,
        lastLogin: admin.lastLogin
      },
      token,
      expiresIn: '24h'
    });

  } catch (error) {
    console.error('Login error:', error);
    return sendServerError(res, 'Login failed. Please try again.');
  }
};

/**
 * Verify Token (for testing)
 * GET /api/auth/verify
 */
const verifyToken = async (req, res) => {
  try {
    const admin = await Admin.findById(req.admin._id).select('-password');
    
    if (!admin || !admin.isActive) {
      return sendUnauthorized(res, 'Admin not found or inactive');
    }

    return sendSuccess(res, 'Token is valid', {
      admin: {
        id: admin._id,
        username: admin.username,
        email: admin.email,
        role: admin.role,
        permissions: admin.permissions,
        lastLogin: admin.lastLogin
      }
    });

  } catch (error) {
    console.error('Token verification error:', error);
    return sendServerError(res, 'Token verification failed');
  }
};

module.exports = {
  login,
  verifyToken
};