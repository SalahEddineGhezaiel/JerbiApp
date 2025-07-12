const jwt = require('jsonwebtoken');
const { sendUnauthorized, sendServerError } = require('../utils/response');

/**
 * JWT Authentication Middleware
 */
const authenticateToken = (req, res, next) => {
  try {
    // Get token from header
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1]; // Bearer TOKEN

    if (!token) {
      return sendUnauthorized(res, 'Access token is required');
    }

    // Verify token
    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
      if (err) {
        if (err.name === 'TokenExpiredError') {
          return sendUnauthorized(res, 'Token has expired');
        }
        if (err.name === 'JsonWebTokenError') {
          return sendUnauthorized(res, 'Invalid token');
        }
        return sendUnauthorized(res, 'Token verification failed');
      }

      // Add admin info to request
      req.admin = decoded;
      next();
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