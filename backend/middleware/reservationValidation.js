const { body, param, query } = require('express-validator');

// Validation for creating a new reservation
const validateCreateReservation = [
  body('nomPrenom')
    .trim()
    .notEmpty()
    .withMessage('Nom et prénom sont requis')
    .isLength({ min: 2, max: 100 })
    .withMessage('Le nom doit contenir entre 2 et 100 caractères'),

  body('email')
    .trim()
    .notEmpty()
    .withMessage('Email est requis')
    .isEmail()
    .withMessage('Format d\'email invalide')
    .normalizeEmail(),

  body('telephone')
    .trim()
    .notEmpty()
    .withMessage('Téléphone est requis')
    .isLength({ min: 8 })
    .withMessage('Le numéro de téléphone doit contenir au moins 8 caractères'),

  body('nombreAdultes')
    .isInt({ min: 1, max: 20 })
    .withMessage('Le nombre d\'adultes doit être entre 1 et 20'),

  body('nombreEnfants')
    .optional()
    .isInt({ min: 0, max: 15 })
    .withMessage('Le nombre d\'enfants doit être entre 0 et 15'),

  body('enfantsParAge.moins_4')
    .optional()
    .isInt({ min: 0 })
    .withMessage('Le nombre d\'enfants de moins de 4 ans doit être positif'),

  body('enfantsParAge.4_8')
    .optional()
    .isInt({ min: 0 })
    .withMessage('Le nombre d\'enfants de 4 à 8 ans doit être positif'),

  body('enfantsParAge.9_12')
    .optional()
    .isInt({ min: 0 })
    .withMessage('Le nombre d\'enfants de 9 à 12 ans doit être positif'),

  body('date')
    .notEmpty()
    .withMessage('Date de réservation est requise')
    .isISO8601()
    .withMessage('Format de date invalide')
    .custom((value) => {
      const date = new Date(value);
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      
      if (date < today) {
        throw new Error('La date de réservation ne peut pas être dans le passé');
      }
      return true;
    }),

  body('activity')
    .notEmpty()
    .withMessage('Activité est requise')
    .isIn([
      'Balade en mer avec kayak',
      'Sortie bateau à Haouaria',
      'Balade en mer avec bateau',
      'Plongée sous marine',
      'Haouaria one day',
      'Camping',
      'Journée crique'
    ])
    .withMessage('Activité non valide'),

  body('status')
    .optional()
    .isIn(['paid', 'confirmed', 'cancelled', 'completed'])
    .withMessage('Statut non valide'),

  body('notes')
    .optional()
    .trim()
    .isLength({ max: 500 })
    .withMessage('Les notes ne peuvent pas dépasser 500 caractères'),

  // Custom validation to check if enfantsParAge totals match nombreEnfants
  body().custom((body) => {
    const nombreEnfants = parseInt(body.nombreEnfants) || 0;
    const enfantsParAge = body.enfantsParAge || {};
    
    const totalEnfantsParAge = (parseInt(enfantsParAge.moins_4) || 0) +
                              (parseInt(enfantsParAge['4_8']) || 0) +
                              (parseInt(enfantsParAge['9_12']) || 0);
    
    if (totalEnfantsParAge !== nombreEnfants) {
      throw new Error('Le total des enfants par âge ne correspond pas au nombre total d\'enfants');
    }
    
    return true;
  })
];

// Validation for updating a reservation
const validateUpdateReservation = [
  param('id')
    .isMongoId()
    .withMessage('ID de réservation invalide'),

  body('nomPrenom')
    .optional()
    .trim()
    .notEmpty()
    .withMessage('Nom et prénom ne peuvent pas être vides')
    .isLength({ min: 2, max: 100 })
    .withMessage('Le nom doit contenir entre 2 et 100 caractères'),

  body('email')
    .optional()
    .trim()
    .notEmpty()
    .withMessage('Email ne peut pas être vide')
    .isEmail()
    .withMessage('Format d\'email invalide')
    .normalizeEmail(),

  body('telephone')
    .optional()
    .trim()
    .notEmpty()
    .withMessage('Téléphone ne peut pas être vide')
    .isLength({ min: 8 })
    .withMessage('Le numéro de téléphone doit contenir au moins 8 caractères'),

  body('nombreAdultes')
    .optional()
    .isInt({ min: 1, max: 20 })
    .withMessage('Le nombre d\'adultes doit être entre 1 et 20'),

  body('nombreEnfants')
    .optional()
    .isInt({ min: 0, max: 15 })
    .withMessage('Le nombre d\'enfants doit être entre 0 et 15'),

  body('enfantsParAge.moins_4')
    .optional()
    .isInt({ min: 0 })
    .withMessage('Le nombre d\'enfants de moins de 4 ans doit être positif'),

  body('enfantsParAge.4_8')
    .optional()
    .isInt({ min: 0 })
    .withMessage('Le nombre d\'enfants de 4 à 8 ans doit être positif'),

  body('enfantsParAge.9_12')
    .optional()
    .isInt({ min: 0 })
    .withMessage('Le nombre d\'enfants de 9 à 12 ans doit être positif'),

  body('date')
    .optional()
    .isISO8601()
    .withMessage('Format de date invalide')
    .custom((value) => {
      if (value) {
        const date = new Date(value);
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        
        if (date < today) {
          throw new Error('La date de réservation ne peut pas être dans le passé');
        }
      }
      return true;
    }),

  body('activity')
    .optional()
    .isIn([
      'Balade en mer avec kayak',
      'Sortie bateau à Haouaria',
      'Balade en mer avec bateau',
      'Plongée sous marine',
      'Haouaria one day',
      'Camping',
      'Journée crique'
    ])
    .withMessage('Activité non valide'),

  body('status')
    .optional()
    .isIn(['paid', 'confirmed', 'cancelled', 'completed'])
    .withMessage('Statut non valide'),

  body('notes')
    .optional()
    .trim()
    .isLength({ max: 500 })
    .withMessage('Les notes ne peuvent pas dépasser 500 caractères'),

  // Custom validation to check if enfantsParAge totals match nombreEnfants
  body().custom((body) => {
    // Only validate if both nombreEnfants and enfantsParAge are provided
    if (body.nombreEnfants !== undefined && body.enfantsParAge) {
      const nombreEnfants = parseInt(body.nombreEnfants) || 0;
      const enfantsParAge = body.enfantsParAge || {};
      
      const totalEnfantsParAge = (parseInt(enfantsParAge.moins_4) || 0) +
                                (parseInt(enfantsParAge['4_8']) || 0) +
                                (parseInt(enfantsParAge['9_12']) || 0);
      
      if (totalEnfantsParAge !== nombreEnfants) {
        throw new Error('Le total des enfants par âge ne correspond pas au nombre total d\'enfants');
      }
    }
    
    return true;
  })
];

// Validation for getting reservation by ID
const validateGetReservation = [
  param('id')
    .isMongoId()
    .withMessage('ID de réservation invalide')
];

// Validation for deleting reservation
const validateDeleteReservation = [
  param('id')
    .isMongoId()
    .withMessage('ID de réservation invalide')
];

// Validation for query parameters
const validateReservationQuery = [
  query('page')
    .optional()
    .isInt({ min: 1 })
    .withMessage('Le numéro de page doit être un entier positif'),

  query('limit')
    .optional()
    .isInt({ min: 1, max: 100 })
    .withMessage('La limite doit être entre 1 et 100'),

  query('sortBy')
    .optional()
    .isIn(['createdAt', 'date', 'nomPrenom', 'activity', 'status'])
    .withMessage('Champ de tri invalide'),

  query('sortOrder')
    .optional()
    .isIn(['asc', 'desc'])
    .withMessage('Ordre de tri invalide'),

  query('status')
    .optional()
    .isIn(['paid', 'confirmed', 'cancelled', 'completed'])
    .withMessage('Statut invalide'),

  query('activity')
    .optional()
    .isIn([
      'Balade en mer avec kayak',
      'Sortie bateau à Haouaria',
      'Balade en mer avec bateau',
      'Plongée sous marine',
      'Haouaria one day',
      'Camping',
      'Journée crique'
    ])
    .withMessage('Activité invalide'),

  query('dateFrom')
    .optional()
    .isISO8601()
    .withMessage('Format de date de début invalide'),

  query('dateTo')
    .optional()
    .isISO8601()
    .withMessage('Format de date de fin invalide'),

  query('search')
    .optional()
    .trim()
    .isLength({ min: 1, max: 100 })
    .withMessage('Le terme de recherche doit contenir entre 1 et 100 caractères')
];

module.exports = {
  validateCreateReservation,
  validateUpdateReservation,
  validateGetReservation,
  validateDeleteReservation,
  validateReservationQuery
};