const { validationResult } = require('express-validator');
const Admin = require('../models/Admin');
const { sendSuccess, sendError, sendServerError, sendUnauthorized, sendNotFound } = require('../utils/response');

/**
 * Get all admins (excluding super-admin)
 * GET /api/admin/list
 */
const getAllAdmins = async (req, res) => {
  try {
    // Check if current admin has permission
    const currentAdmin = await Admin.findById(req.admin.adminId);
    if (!currentAdmin || (!currentAdmin.permissions.canCreateAdmins && currentAdmin.role !== 'super-admin')) {
      return sendUnauthorized(res, 'Insufficient permissions to view admins');
    }

    // Get all admins except the current one
    const admins = await Admin.find({
      _id: { $ne: req.admin.adminId },
      role: { $ne: 'super-admin' }
    })
    .select('-password')
    .populate('createdBy', 'username email')
    .sort({ createdAt: -1 });

    return sendSuccess(res, 'Admins retrieved successfully', {
      admins,
      total: admins.length
    });

  } catch (error) {
    console.error('Get admins error:', error);
    return sendServerError(res, 'Failed to retrieve admins');
  }
};

/**
 * Create new admin
 * POST /api/admin/create
 */
const createAdmin = async (req, res) => {
  try {
    // Check for validation errors
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return sendError(res, 'Validation failed', errors.array(), 422);
    }

    // Check if current admin has permission
    const currentAdmin = await Admin.findById(req.admin.adminId);
    if (!currentAdmin || (!currentAdmin.permissions.canCreateAdmins && currentAdmin.role !== 'super-admin')) {
      return sendUnauthorized(res, 'Insufficient permissions to create admins');
    }

    const { username, email, password, permissions } = req.body;

    // Check if username or email already exists
    const existingAdmin = await Admin.findOne({
      $or: [{ username }, { email }]
    });

    if (existingAdmin) {
      return sendError(res, 'Username or email already exists', null, 409);
    }

    // Set default permissions for regular admin
    const defaultPermissions = {
      canCreateAdmins: false,
      canDeleteAdmins: false,
      canViewReservations: true,
      canCreateReservations: true,
      canEditReservations: true,
      canDeleteReservations: false,
      canViewStatistics: true,
      canManageSettings: false,
      ...permissions // Override with provided permissions
    };

    // Create new admin
    const newAdmin = new Admin({
      username,
      email,
      password,
      role: 'admin',
      permissions: defaultPermissions,
      createdBy: req.admin.adminId,
      isActive: true
    });

    await newAdmin.save();

    // Return admin without password
    const adminResponse = {
      id: newAdmin._id,
      username: newAdmin.username,
      email: newAdmin.email,
      role: newAdmin.role,
      permissions: newAdmin.permissions,
      createdBy: currentAdmin.username,
      isActive: newAdmin.isActive,
      createdAt: newAdmin.createdAt
    };

    return sendSuccess(res, 'Admin created successfully', {
      admin: adminResponse
    }, 201);

  } catch (error) {
    console.error('Create admin error:', error);
    return sendServerError(res, 'Failed to create admin');
  }
};

/**
 * Update admin permissions
 * PUT /api/admin/:id/permissions
 */
const updateAdminPermissions = async (req, res) => {
  try {
    // Check for validation errors
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return sendError(res, 'Validation failed', errors.array(), 422);
    }

    // Check if current admin has permission
    const currentAdmin = await Admin.findById(req.admin.adminId);
    if (!currentAdmin || (!currentAdmin.permissions.canCreateAdmins && currentAdmin.role !== 'super-admin')) {
      return sendUnauthorized(res, 'Insufficient permissions to update admin permissions');
    }

    const { id } = req.params;
    const { permissions } = req.body;

    // Find the admin to update
    const adminToUpdate = await Admin.findById(id);
    if (!adminToUpdate) {
      return sendNotFound(res, 'Admin not found');
    }

    // Prevent updating super-admin
    if (adminToUpdate.role === 'super-admin') {
      return sendError(res, 'Cannot update super-admin permissions');
    }

    // Prevent self-update unless super-admin
    if (adminToUpdate._id.toString() === req.admin.adminId && currentAdmin.role !== 'super-admin') {
      return sendError(res, 'Cannot update your own permissions');
    }

    // Update permissions
    adminToUpdate.permissions = {
      ...adminToUpdate.permissions,
      ...permissions
    };

    await adminToUpdate.save();

    return sendSuccess(res, 'Admin permissions updated successfully', {
      admin: {
        id: adminToUpdate._id,
        username: adminToUpdate.username,
        email: adminToUpdate.email,
        permissions: adminToUpdate.permissions
      }
    });

  } catch (error) {
    console.error('Update admin permissions error:', error);
    return sendServerError(res, 'Failed to update admin permissions');
  }
};

/**
 * Deactivate admin
 * PUT /api/admin/:id/deactivate
 */
const deactivateAdmin = async (req, res) => {
  try {
    // Check if current admin has permission
    const currentAdmin = await Admin.findById(req.admin.adminId);
    if (!currentAdmin || (!currentAdmin.permissions.canDeleteAdmins && currentAdmin.role !== 'super-admin')) {
      return sendUnauthorized(res, 'Insufficient permissions to deactivate admins');
    }

    const { id } = req.params;

    // Find the admin to deactivate
    const adminToDeactivate = await Admin.findById(id);
    if (!adminToDeactivate) {
      return sendNotFound(res, 'Admin not found');
    }

    // Prevent deactivating super-admin
    if (adminToDeactivate.role === 'super-admin') {
      return sendError(res, 'Cannot deactivate super-admin');
    }

    // Prevent self-deactivation
    if (adminToDeactivate._id.toString() === req.admin.adminId) {
      return sendError(res, 'Cannot deactivate yourself');
    }

    // Deactivate admin
    adminToDeactivate.isActive = false;
    await adminToDeactivate.save();

    return sendSuccess(res, 'Admin deactivated successfully', {
      admin: {
        id: adminToDeactivate._id,
        username: adminToDeactivate.username,
        isActive: adminToDeactivate.isActive
      }
    });

  } catch (error) {
    console.error('Deactivate admin error:', error);
    return sendServerError(res, 'Failed to deactivate admin');
  }
};

/**
 * Reactivate admin
 * PUT /api/admin/:id/activate
 */
const activateAdmin = async (req, res) => {
  try {
    // Check if current admin has permission
    const currentAdmin = await Admin.findById(req.admin.adminId);
    if (!currentAdmin || (!currentAdmin.permissions.canCreateAdmins && currentAdmin.role !== 'super-admin')) {
      return sendUnauthorized(res, 'Insufficient permissions to activate admins');
    }

    const { id } = req.params;

    // Find the admin to activate
    const adminToActivate = await Admin.findById(id);
    if (!adminToActivate) {
      return sendNotFound(res, 'Admin not found');
    }

    // Activate admin
    adminToActivate.isActive = true;
    await adminToActivate.save();

    return sendSuccess(res, 'Admin activated successfully', {
      admin: {
        id: adminToActivate._id,
        username: adminToActivate.username,
        isActive: adminToActivate.isActive
      }
    });

  } catch (error) {
    console.error('Activate admin error:', error);
    return sendServerError(res, 'Failed to activate admin');
  }
};

/**
 * Get current admin profile with permissions
 * GET /api/admin/profile
 */
const getAdminProfile = async (req, res) => {
  try {
    const admin = await Admin.findById(req.admin.adminId)
      .select('-password')
      .populate('createdBy', 'username email');

    if (!admin) {
      return sendNotFound(res, 'Admin not found');
    }

    return sendSuccess(res, 'Admin profile retrieved successfully', {
      admin: {
        id: admin._id,
        username: admin.username,
        email: admin.email,
        role: admin.role,
        permissions: admin.permissions,
        createdBy: admin.createdBy,
        isActive: admin.isActive,
        lastLogin: admin.lastLogin,
        createdAt: admin.createdAt
      }
    });

  } catch (error) {
    console.error('Get admin profile error:', error);
    return sendServerError(res, 'Failed to retrieve admin profile');
  }
};

module.exports = {
  getAllAdmins,
  createAdmin,
  updateAdminPermissions,
  deactivateAdmin,
  activateAdmin,
  getAdminProfile
};