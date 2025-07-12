require('dotenv').config();
const mongoose = require('mongoose');
const Admin = require('../models/Admin');

const updateAdmin = async () => {
  try {
    // Connect to MongoDB
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('Connected to MongoDB');

    // Find the existing admin
    const existingAdmin = await Admin.findOne({ username: 'admin' });
    if (!existingAdmin) {
      console.log('❌ Admin user not found!');
      process.exit(1);
    }

    console.log('📋 Current admin permissions:', existingAdmin.permissions);

    // Update admin with full permissions
    existingAdmin.permissions = {
      canCreateAdmins: true,
      canDeleteAdmins: true,
      canViewReservations: true,
      canCreateReservations: true,
      canEditReservations: true,
      canDeleteReservations: true,
      canViewStatistics: true,
      canManageSettings: true
    };

    // Ensure role is super-admin
    existingAdmin.role = 'super-admin';

    await existingAdmin.save();

    console.log('✅ Admin user updated successfully!');
    console.log('📋 New permissions:', existingAdmin.permissions);
    console.log('👑 Role:', existingAdmin.role);

  } catch (error) {
    console.error('❌ Error updating admin:', error.message);
  } finally {
    await mongoose.disconnect();
    console.log('Disconnected from MongoDB');
    process.exit(0);
  }
};

updateAdmin();