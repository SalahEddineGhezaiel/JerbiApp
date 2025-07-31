class AppStrings {
  // App Info
  static const String appName = 'Jerbi Events';
  static const String appVersion = '1.0.0';
  
  // Authentication
  static const String loginTitle = 'Se Connecter';
  static const String loginSubtitle = 'Accès administrateur';
  static const String loginButton = 'Se Connecter';
  static const String loginSuccess = 'Connexion réussie!';
  static const String loginErrorInvalid = 'Identifiant ou mot de passe invalide. Veuillez réessayer.';
  static const String loginErrorGeneral = 'Une erreur s\'est produite. Veuillez réessayer.';
  static const String usernameHint = 'Identifiant';
  static const String passwordHint = 'Mot De Passe';
  static const String usernameRequired = 'Veuillez saisir votre identifiant';
  static const String passwordRequired = 'Veuillez saisir votre mot de passe';
  static const String passwordMinLength = 'Le mot de passe doit contenir au moins 6 caractères';
  
  // Navigation
  static const String navReservations = 'Réservations';
  static const String navStatistics = 'Statistiques';
  static const String navSettings = 'Paramètres';
  
  // Reservations
  static const String reservationsTitle = 'Réservations';
  static const String reservationsEmpty = 'Aucune réservation trouvée';
  static const String reservationsEmptySubtitle = 'Les réservations apparaîtront ici';
  static const String searchHint = 'Rechercher';
  static const String addReservation = 'Ajouter une Réservation';
  static const String editReservation = 'Modifier la Réservation';
  static const String deleteReservation = 'Supprimer la réservation';
  static const String reservationDetails = 'Réservation de';
  static const String reservationAdded = 'ajoutée avec succès';
  static const String reservationUpdated = 'modifiée avec succès';
  static const String reservationDeleted = 'supprimée';
  static const String deleteConfirmation = 'Êtes-vous sûr de vouloir supprimer la réservation de';
  static const String deleteWarning = 'Cette action est irréversible.';
  
  // Form Fields
  static const String clientInfo = 'Informations Client';
  static const String reservationInfo = 'Détails de la Réservation';
  static const String nameLabel = 'Nom et Prénom';
  static const String nameHint = 'Ex: Ahmed Ben Ali';
  static const String emailLabel = 'Email';
  static const String emailHint = 'Ex: ahmed@email.com';
  static const String phoneLabel = 'Téléphone';
  static const String phoneHint = 'Ex: +216 98 123 456';
  static const String adultsLabel = 'Nombre d\'adultes';
  static const String adultsHint = '1';
  static const String childrenLabel = 'Enfants par tranche d\'âge';
  static const String dateLabel = 'Date de la réservation';
  static const String dateHint = 'Sélectionner une date';
  static const String activityLabel = 'Activité';
  static const String activityHint = 'Sélectionner une activité';
  
  // Validation Messages
  static const String nameRequired = 'Le nom et prénom sont requis';
  static const String nameMinLength = 'Le nom doit contenir au moins 2 caractères';
  static const String emailRequired = 'L\'email est requis';
  static const String emailInvalid = 'Veuillez entrer un email valide';
  static const String phoneRequired = 'Le téléphone est requis';
  static const String phoneMinLength = 'Veuillez entrer un numéro valide';
  static const String adultsRequired = 'Le nombre d\'adultes est requis';
  static const String adultsMinimum = 'Minimum 1 adulte requis';
  static const String dateRequired = 'Veuillez sélectionner une date';
  static const String activityRequired = 'Veuillez sélectionner une activité';
  
  // Age Ranges
  static const String ageLess4 = 'Moins de 4 ans';
  static const String age4to8 = 'De 4 à 8 ans';
  static const String age9to12 = 'De 9 à 12 ans';
  static const String childrenTotal = 'Total:';
  static const String childrenSingular = 'enfant';
  static const String childrenPlural = 'enfants';
  static const String noChildren = 'Aucun enfant';
  
  // Activities
  static const String activityKayak = 'Balade en mer avec kayak';
  static const String activityBoatHaouaria = 'Sortie bateau à Haouaria';
  static const String activityBoat = 'Balade en mer avec bateau';
  static const String activityDiving = 'Plongée sous marine';
  static const String activityHaouariaDay = 'Haouaria one day';
  static const String activityCamping = 'Camping';
  static const String activityCrique = 'Journée crique';
  
  // Buttons
  static const String cancel = 'Annuler';
  static const String confirm = 'Confirmer';
  static const String save = 'Enregistrer';
  static const String edit = 'Modifier';
  static const String delete = 'Supprimer';
  static const String close = 'Fermer';
  static const String add = 'Ajouter';
  
  // Statistics
  static const String statisticsTitle = 'Statistiques';
  static const String totalReservations = 'Total Réservations';
  static const String pendingReservations = 'En Attente';
  static const String confirmedReservations = 'Confirmées';
  static const String paidReservations = 'Payées';
  static const String cancelledReservations = 'Annulées';
  static const String reservationEvolution = 'Évolution des Réservations';
  static const String activityBreakdown = 'Répartition par Activité';
  static const String chartPlaceholder = 'Graphique à implémenter';
  
  // Time Periods
  static const String today = 'Aujourd\'hui';
  static const String thisWeek = 'Cette semaine';
  static const String thisMonth = 'Ce mois';
  static const String thisYear = 'Cette année';
  
  // Settings
  static const String settingsTitle = 'Paramètres';
  static const String profileSection = 'Profil Administrateur';
  static const String preferencesSection = 'Préférences';
  static const String userManagementSection = 'Gestion des Utilisateurs';
  static const String dataSection = 'Données';
  static const String aboutSection = 'À propos';
  
  // Profile
  static const String adminProfile = 'Admin Principal';
  static const String adminEmail = 'admin@jerbi-events.com';
  static const String adminRole = 'Super Administrateur';
  static const String editProfile = 'Modifier le profil';
  static const String editProfileSubtitle = 'Nom, email, mot de passe';
  static const String security = 'Sécurité';
  static const String securitySubtitle = 'Changer le mot de passe';
  
  // Preferences
  static const String notifications = 'Notifications';
  static const String notificationsSubtitle = 'Recevoir les notifications push';
  static const String darkMode = 'Mode sombre';
  static const String darkModeSubtitle = 'Activer le thème sombre';
  static const String language = 'Langue';
  static const String languageFrench = 'Français';
  
  // User Management
  static const String manageAdmins = 'Gérer les administrateurs';
  static const String manageAdminsSubtitle = 'Ajouter, modifier, supprimer';
  static const String permissions = 'Permissions';
  static const String permissionsSubtitle = 'Gérer les droits d\'accès';
  
  // Data Management
  static const String exportData = 'Exporter les données';
  static const String exportDataSubtitle = 'Télécharger les réservations';
  static const String backup = 'Sauvegarde';
  static const String backupSubtitle = 'Sauvegarder la base de données';
  static const String restore = 'Restaurer';
  static const String restoreSubtitle = 'Restaurer depuis une sauvegarde';
  
  // About
  static const String appVersionLabel = 'Version de l\'application';
  static const String helpSupport = 'Aide et support';
  static const String helpSupportSubtitle = 'Documentation et contact';
  static const String logout = 'Se déconnecter';
  static const String logoutSubtitle = 'Quitter l\'application';
  static const String logoutConfirmation = 'Êtes-vous sûr de vouloir vous déconnecter ?';
  
  // Placeholder Messages
  static const String featureNotImplemented = 'À implémenter';
  static const String filtersPlaceholder = 'Filtres - À implémenter';
  static const String editProfilePlaceholder = 'Modifier le profil - À implémenter';
  static const String changePasswordPlaceholder = 'Changer le mot de passe - À implémenter';
  static const String languageSelectionPlaceholder = 'Sélection de langue - À implémenter';
  static const String userManagementPlaceholder = 'Gestion des utilisateurs - À implémenter';
  static const String permissionsPlaceholder = 'Gestion des permissions - À implémenter';
  static const String exportPlaceholder = 'Export des données - À implémenter';
  static const String backupPlaceholder = 'Sauvegarde - À implémenter';
  static const String restorePlaceholder = 'Restauration - À implémenter';
  static const String helpPlaceholder = 'Aide et support - À implémenter';
  static const String logoutPlaceholder = 'Déconnexion - À implémenter';
  
  // Detail Labels
  static const String emailDetail = 'Email';
  static const String phoneDetail = 'Téléphone';
  static const String adultsDetail = 'Adultes';
  static const String adultSingular = 'adulte';
  static const String adultPlural = 'adultes';
  static const String childrenDetail = 'Enfants';
  static const String activityDetail = 'Activité';
  static const String dateDetail = 'Date';
}