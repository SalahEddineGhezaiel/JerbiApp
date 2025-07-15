const Reservation = require('../models/Reservation');
const { validationResult } = require('express-validator');

// Get all reservations with optional filtering
const getAllReservations = async (req, res) => {
  try {
    const { 
      page = 1, 
      limit = 10, 
      sortBy = 'createdAt', 
      sortOrder = 'desc',
      status,
      activity,
      dateFrom,
      dateTo,
      search
    } = req.query;

    // Build filter object
    const filter = {};
    
    if (status) {
      filter.status = status;
    }
    
    if (activity) {
      filter.activity = activity;
    }
    
    if (dateFrom || dateTo) {
      filter.date = {};
      if (dateFrom) {
        filter.date.$gte = new Date(dateFrom);
      }
      if (dateTo) {
        filter.date.$lte = new Date(dateTo);
      }
    }
    
    if (search) {
      filter.$or = [
        { nomPrenom: { $regex: search, $options: 'i' } },
        { email: { $regex: search, $options: 'i' } },
        { telephone: { $regex: search, $options: 'i' } }
      ];
    }

    // Calculate pagination
    const skip = (parseInt(page) - 1) * parseInt(limit);
    const sortOptions = {};
    sortOptions[sortBy] = sortOrder === 'desc' ? -1 : 1;

    // Execute query
    const reservations = await Reservation.find(filter)
      .sort(sortOptions)
      .skip(skip)
      .limit(parseInt(limit))
      .populate('createdBy', 'username')
      .populate('updatedBy', 'username');

    // Get total count for pagination
    const total = await Reservation.countDocuments(filter);
    const totalPages = Math.ceil(total / parseInt(limit));

    res.json({
      success: true,
      data: {
        reservations,
        pagination: {
          currentPage: parseInt(page),
          totalPages,
          totalItems: total,
          itemsPerPage: parseInt(limit),
          hasNextPage: parseInt(page) < totalPages,
          hasPrevPage: parseInt(page) > 1
        }
      }
    });
  } catch (error) {
    console.error('Error fetching reservations:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de la récupération des réservations',
      error: error.message
    });
  }
};

// Get single reservation by ID
const getReservationById = async (req, res) => {
  try {
    const { id } = req.params;
    
    const reservation = await Reservation.findById(id)
      .populate('createdBy', 'username')
      .populate('updatedBy', 'username');
    
    if (!reservation) {
      return res.status(404).json({
        success: false,
        message: 'Réservation non trouvée'
      });
    }
    
    res.json({
      success: true,
      data: reservation
    });
  } catch (error) {
    console.error('Error fetching reservation:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de la récupération de la réservation',
      error: error.message
    });
  }
};

// Create new reservation
const createReservation = async (req, res) => {
  try {
    // Check for validation errors
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Données de validation invalides',
        errors: errors.array()
      });
    }

    const reservationData = {
      ...req.body,
      createdBy: req.admin ? req.admin.id : null
    };

    const reservation = new Reservation(reservationData);
    await reservation.save();

    // Populate the created reservation
    await reservation.populate('createdBy', 'username');

    res.status(201).json({
      success: true,
      message: 'Réservation créée avec succès',
      data: reservation
    });
  } catch (error) {
    console.error('Error creating reservation:', error);
    
    // Handle validation errors
    if (error.name === 'ValidationError') {
      const validationErrors = Object.values(error.errors).map(err => ({
        field: err.path,
        message: err.message
      }));
      
      return res.status(400).json({
        success: false,
        message: 'Erreur de validation',
        errors: validationErrors
      });
    }
    
    res.status(500).json({
      success: false,
      message: 'Erreur lors de la création de la réservation',
      error: error.message
    });
  }
};

// Update reservation
const updateReservation = async (req, res) => {
  try {
    const { id } = req.params;
    
    // Check for validation errors
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Données de validation invalides',
        errors: errors.array()
      });
    }

    const updateData = {
      ...req.body,
      updatedBy: req.admin ? req.admin.id : null
    };

    const reservation = await Reservation.findByIdAndUpdate(
      id,
      updateData,
      { 
        new: true, 
        runValidators: true 
      }
    ).populate('createdBy', 'username')
     .populate('updatedBy', 'username');

    if (!reservation) {
      return res.status(404).json({
        success: false,
        message: 'Réservation non trouvée'
      });
    }

    res.json({
      success: true,
      message: 'Réservation mise à jour avec succès',
      data: reservation
    });
  } catch (error) {
    console.error('Error updating reservation:', error);
    
    // Handle validation errors
    if (error.name === 'ValidationError') {
      const validationErrors = Object.values(error.errors).map(err => ({
        field: err.path,
        message: err.message
      }));
      
      return res.status(400).json({
        success: false,
        message: 'Erreur de validation',
        errors: validationErrors
      });
    }
    
    res.status(500).json({
      success: false,
      message: 'Erreur lors de la mise à jour de la réservation',
      error: error.message
    });
  }
};

// Delete reservation
const deleteReservation = async (req, res) => {
  try {
    const { id } = req.params;
    
    const reservation = await Reservation.findByIdAndDelete(id);
    
    if (!reservation) {
      return res.status(404).json({
        success: false,
        message: 'Réservation non trouvée'
      });
    }
    
    res.json({
      success: true,
      message: 'Réservation supprimée avec succès',
      data: reservation
    });
  } catch (error) {
    console.error('Error deleting reservation:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de la suppression de la réservation',
      error: error.message
    });
  }
};

// Get reservation statistics
const getReservationStats = async (req, res) => {
  try {
    const { dateFrom, dateTo } = req.query;
    
    // Build date filter
    const dateFilter = {};
    if (dateFrom || dateTo) {
      dateFilter.date = {};
      if (dateFrom) {
        dateFilter.date.$gte = new Date(dateFrom);
      }
      if (dateTo) {
        dateFilter.date.$lte = new Date(dateTo);
      }
    }

    // Get basic stats
    const totalReservations = await Reservation.countDocuments(dateFilter);
    const confirmedReservations = await Reservation.countDocuments({
      ...dateFilter,
      status: 'confirmed'
    });
    const pendingReservations = await Reservation.countDocuments({
      ...dateFilter,
      status: 'pending'
    });
    const cancelledReservations = await Reservation.countDocuments({
      ...dateFilter,
      status: 'cancelled'
    });

    // Get activity stats
    const activityStats = await Reservation.aggregate([
      { $match: dateFilter },
      {
        $group: {
          _id: '$activity',
          count: { $sum: 1 },
          totalAdults: { $sum: '$nombreAdultes' },
          totalChildren: { $sum: '$nombreEnfants' }
        }
      },
      { $sort: { count: -1 } }
    ]);

    // Get monthly stats (last 12 months)
    const monthlyStats = await Reservation.aggregate([
      {
        $match: {
          createdAt: {
            $gte: new Date(new Date().setMonth(new Date().getMonth() - 12))
          }
        }
      },
      {
        $group: {
          _id: {
            year: { $year: '$createdAt' },
            month: { $month: '$createdAt' }
          },
          count: { $sum: 1 },
          totalPeople: { $sum: '$totalPersonnes' }
        }
      },
      { $sort: { '_id.year': 1, '_id.month': 1 } }
    ]);

    res.json({
      success: true,
      data: {
        overview: {
          total: totalReservations,
          confirmed: confirmedReservations,
          pending: pendingReservations,
          cancelled: cancelledReservations
        },
        activities: activityStats,
        monthly: monthlyStats
      }
    });
  } catch (error) {
    console.error('Error fetching reservation stats:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de la récupération des statistiques',
      error: error.message
    });
  }
};

// Get available activities
const getAvailableActivities = async (req, res) => {
  try {
    const activities = Reservation.getAvailableActivities();
    
    res.json({
      success: true,
      data: activities
    });
  } catch (error) {
    console.error('Error fetching activities:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de la récupération des activités',
      error: error.message
    });
  }
};

module.exports = {
  getAllReservations,
  getReservationById,
  createReservation,
  updateReservation,
  deleteReservation,
  getReservationStats,
  getAvailableActivities
};