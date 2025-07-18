const jwt = require('jsonwebtoken');
const Admin = require('../models/Admin');
const { sendUnauthorized, sendServerError } = require('../utils/response');

/**
 * JWT Authentication Middleware
 */
const authenticateToken = async (req, res, next) => {
  try {
    // Get token from header
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1]; // Bearer TOKEN

    if (!token) {
      return sendUnauthorized(res, 'Access token is required');
    }

    // Verify token
    jwt.verify(token, process.env.JWT_SECRET, async (err, decoded) => {
      if (err) {
        if (err.name === 'TokenExpiredError') {
          return sendUnauthorized(res, 'Token has expired');
        }
        if (err.name === 'JsonWebTokenError') {
          return sendUnauthorized(res, 'Invalid token');
        }
        return sendUnauthorized(res, 'Token verification failed');
      }

      try {
        // Fetch full admin object from database with permissions
        const admin = await Admin.findById(decoded.adminId).select('-password');
        
        if (!admin || !admin.isActive) {
          return sendUnauthorized(res, 'Admin not found or inactive');
        }

        // Add full admin info to request
        req.admin = admin;
        next();
      } catch (dbError) {
        console.error('Database error in auth middleware:', dbError);
        return sendServerError(res, 'Authentication failed');
      }
    });

  } catch (error) {
    console.error('Auth middleware error:', error);
    return sendServerError(res, 'Authentication failed');
  }
};

/**
 * Role-based authorization middleware
 */
const authorizeRole = (roles = []) => {
  return (req, res, next) => {
    if (!req.admin) {
      return sendUnauthorized(res, 'Authentication required');
    }

    // If no roles specified, just check if authenticated
    if (roles.length === 0) {
      return next();
    }

    // Check if admin has required role
    if (!roles.includes(req.admin.role)) {
      return sendUnauthorized(res, 'Insufficient permissions');
    }

    next();
  };
};

module.exports = {
  authenticateToken,
  authorizeRole
};