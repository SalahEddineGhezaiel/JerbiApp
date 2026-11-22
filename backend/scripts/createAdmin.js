require('dotenv').config();
const mongoose = require('mongoose');
const Admin = require('../models/Admin');

const createAdmin = async () => {
  try {
    const adminPassword = process.env.ADMIN_PASSWORD;
    if (!adminPassword) {
      console.error('Set ADMIN_PASSWORD (e.g. ADMIN_PASSWORD=... npm run create-admin)');
      process.exit(1);
    }

    // Connect to MongoDB
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('Connected to MongoDB');

    // Check if admin already exists
    const existingAdmin = await Admin.findOne({ username: 'admin' });
    if (existingAdmin) {
      console.log('Admin user already exists!');
      process.exit(0);
    }

    // Create admin user
    const adminData = {
      username: 'admin',
      email: 'admin@jerbi-events.com',
      password: adminPassword, // hashed automatically by the model
      role: 'super-admin',
      permissions: {
        canCreateAdmins: true,
        canDeleteAdmins: true,
        canViewReservations: true,
        canCreateReservations: true,
        canEditReservations: true,
        canDeleteReservations: true,
        canViewStatistics: true,
        canManageSettings: true
      },
      isActive: true
    };

    const admin = new Admin(adminData);
    await admin.save();

    console.log('✅ Admin user created successfully!');
    console.log('Username: admin');
    console.log('Email: admin@jerbi-events.com');

  } catch (error) {
    console.error('❌ Error creating admin:', error.message);
  } finally {
    await mongoose.disconnect();
    console.log('Disconnected from MongoDB');
    process.exit(0);
  }
};

createAdmin();