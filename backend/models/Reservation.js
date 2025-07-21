const mongoose = require('mongoose');

const reservationSchema = new mongoose.Schema({
  nomPrenom: {
    type: String,
    required: [true, 'Nom et prénom sont requis'],
    trim: true,
    minlength: [2, 'Le nom doit contenir au moins 2 caractères'],
    maxlength: [100, 'Le nom ne peut pas dépasser 100 caractères']
  },
  email: {
    type: String,
    required: [true, 'Email est requis'],
    trim: true,
    lowercase: true,
    match: [/^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$/, 'Veuillez entrer un email valide']
  },
  telephone: {
    type: String,
    required: [true, 'Téléphone est requis'],
    trim: true,
    minlength: [8, 'Le numéro de téléphone doit contenir au moins 8 caractères']
  },
  nombreAdultes: {
    type: Number,
    required: [true, 'Nombre d\'adultes est requis'],
    min: [1, 'Au moins 1 adulte est requis'],
    max: [20, 'Maximum 20 adultes autorisés']
  },
  nombreEnfants: {
    type: Number,
    default: 0,
    min: [0, 'Le nombre d\'enfants ne peut pas être négatif'],
    max: [15, 'Maximum 15 enfants autorisés']
  },
  enfantsParAge: {
    moins_4: {
      type: Number,
      default: 0,
      min: [0, 'Le nombre d\'enfants ne peut pas être négatif']
    },
    "4_8": {
      type: Number,
      default: 0,
      min: [0, 'Le nombre d\'enfants ne peut pas être négatif']
    },
    "9_12": {
      type: Number,
      default: 0,
      min: [0, 'Le nombre d\'enfants ne peut pas être négatif']
    }
  },
  date: {
    type: Date,
    required: [true, 'Date de réservation est requise'],
    validate: {
      validator: function(value) {
        return value >= new Date();
      },
      message: 'La date de réservation ne peut pas être dans le passé'
    }
  },
  activity: {
    type: String,
    required: [true, 'Activité est requise'],
    enum: {
      values: [
        'Balade en mer avec kayak',
        'Sortie bateau à Haouaria',
        'Balade en mer avec bateau',
        'Plongée sous marine',
        'Haouaria one day',
        'Camping',
        'Journée crique'
      ],
      message: 'Activité non valide'
    }
  },
  status: {
    type: String,
    default: 'confirmed',
    enum: {
      values: ['paid', 'confirmed', 'cancelled', 'completed'],
      message: 'Statut non valide'
    }
  },
  notes: {
    type: String,
    maxlength: [500, 'Les notes ne peuvent pas dépasser 500 caractères'],
    trim: true
  },
  totalPersonnes: {
    type: Number
  },
  createdBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Admin',
    required: false
  },
  updatedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Admin',
    required: false
  }
}, {
  timestamps: true
});

// Virtual for total number of people
reservationSchema.virtual('totalPersonnesCalculated').get(function() {
  return this.nombreAdultes + this.nombreEnfants;
});

// Pre-save middleware to calculate total people and validate children ages
reservationSchema.pre('save', function(next) {
  // Calculate total people
  this.totalPersonnes = this.nombreAdultes + this.nombreEnfants;
  
  // Validate that enfantsParAge totals match nombreEnfants
  const totalEnfantsParAge = (this.enfantsParAge.moins_4 || 0) + 
                            (this.enfantsParAge["4_8"] || 0) + 
                            (this.enfantsParAge["9_12"] || 0);
  
  if (totalEnfantsParAge !== this.nombreEnfants) {
    return next(new Error('Le total des enfants par âge ne correspond pas au nombre total d\'enfants'));
  }
  
  next();
});

// Instance method to get formatted date
reservationSchema.methods.getFormattedDate = function() {
  return this.date.toLocaleDateString('fr-FR', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric'
  });
};

// Instance method to get formatted children details
reservationSchema.methods.getFormattedEnfants = function() {
  if (this.nombreEnfants === 0) return 'Aucun enfant';
  
  const parts = [];
  if (this.enfantsParAge.moins_4 > 0) {
    parts.push(`${this.enfantsParAge.moins_4} × Moins de 4 ans`);
  }
  if (this.enfantsParAge["4_8"] > 0) {
    parts.push(`${this.enfantsParAge["4_8"]} × De 4 à 8 ans`);
  }
  if (this.enfantsParAge["9_12"] > 0) {
    parts.push(`${this.enfantsParAge["9_12"]} × De 9 à 12 ans`);
  }
  
  return parts.length > 0 ? parts.join(', ') : `${this.nombreEnfants} enfant${this.nombreEnfants > 1 ? 's' : ''}`;
};

// Static method to get available activities
reservationSchema.statics.getAvailableActivities = function() {
  return [
    'Balade en mer avec kayak',
    'Sortie bateau à Haouaria',
    'Balade en mer avec bateau',
    'Plongée sous marine',
    'Haouaria one day',
    'Camping',
    'Journée crique'
  ];
};

// Index for better query performance
reservationSchema.index({ date: 1 });
reservationSchema.index({ activity: 1 });
reservationSchema.index({ status: 1 });
reservationSchema.index({ email: 1 });
reservationSchema.index({ createdAt: -1 });

// Compound index for filtering
reservationSchema.index({ date: 1, activity: 1 });

module.exports = mongoose.model('Reservation', reservationSchema);