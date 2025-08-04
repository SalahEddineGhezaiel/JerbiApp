import 'package:flutter/material.dart';
import '../../shared/constants/constants.dart';
import '../../shared/widgets/page_header.dart';
import '../../shared/utils/token_manager.dart';
import '../../shared/utils/date_formatter.dart';
import 'models/statistics_model.dart';
import 'services/statistics_service.dart';
import 'widgets/widgets.dart';
import 'dialogs/dialogs.dart';

class StatisticsContent extends StatefulWidget {
  const StatisticsContent({super.key});

  @override
  State<StatisticsContent> createState() => _StatisticsContentState();
}

class _StatisticsContentState extends State<StatisticsContent> {
  // Filter state
  DateTime? _filterStartDate;
  DateTime? _filterEndDate;
  String? _filterLabel;
  bool _isAllTimeFilter = false; // Track if "all time" filter is active

  // Data state
  ReservationStatistics? _statistics;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Set default filter to "this month"
    _setDefaultFilter();
    _loadStatistics();
  }

  // Set the default filter to "this month"
  void _setDefaultFilter() {
    final now = DateTime.now();
    _filterLabel = 'Ce mois';
    _filterStartDate = DateTime(now.year, now.month, 1);
    _filterEndDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    _isAllTimeFilter = false;
  }

  // Load statistics based on selected period
  Future<void> _loadStatistics() async {
    // Check permission first
    if (!TokenManager.canViewStatistics()) {
      setState(() {
        _errorMessage = 'Vous n\'avez pas la permission de voir les statistiques';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      ReservationStatistics statistics;

      // Handle different filter types
      if (_isAllTimeFilter) {
        // Show all time statistics (no date filters)
        statistics = await StatisticsService.getAllTimeStats();
      } else if (_filterStartDate != null || _filterEndDate != null) {
        // Use custom filter dates
        statistics = await StatisticsService.getStatistics(
          dateFrom: _filterStartDate,
          dateTo: _filterEndDate,
        );
      } else {
        // Use default period (this month) when no filter is set
        statistics = await StatisticsService.getThisMonthStats();
      }

      setState(() {
        _statistics = statistics;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }



  // Handle refresh
  Future<void> _handleRefresh() async {
    await _loadStatistics();
  }

  // Show filter dialog
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => StatisticsFilterDialog(
        initialStartDate: _filterStartDate,
        initialEndDate: _filterEndDate,
        onApplyFilters: (startDate, endDate) {
          setState(() {
            _filterStartDate = startDate;
            _filterEndDate = endDate;
            _isAllTimeFilter = false; // Reset all time filter when using custom dates

            // Create a label for the filter
            if (startDate != null && endDate != null) {
              // Check if it's the same day (single date selection)
              final isSameDay = startDate.year == endDate.year &&
                               startDate.month == endDate.month &&
                               startDate.day == endDate.day;

              if (isSameDay) {
                _filterLabel = DateFormatter.formatDate(startDate);
              } else {
                _filterLabel = '${DateFormatter.formatDate(startDate)} - ${DateFormatter.formatDate(endDate)}';
              }
            } else if (startDate != null) {
              _filterLabel = DateFormatter.formatDate(startDate);
            } else if (endDate != null) {
              _filterLabel = 'Jusqu\'au ${DateFormatter.formatDate(endDate)}';
            } else {
              _filterLabel = null;
            }
          });

          // Load statistics with filter
          _loadStatistics();
        },
      ),
    );
  }

  // Check if we have active filters
  bool get _hasActiveFilters {
    return _filterStartDate != null || _filterEndDate != null || _filterLabel != null || _isAllTimeFilter;
  }

  // Clear all filters
  void _clearFilters() {
    setState(() {
      _filterStartDate = null;
      _filterEndDate = null;
      _filterLabel = null;
      _isAllTimeFilter = false;
    });
    _loadStatistics();
  }

  // Handle quick filter selection
  void _handleQuickFilter(String period) {
    setState(() {
      // Reset all filter states
      _filterStartDate = null;
      _filterEndDate = null;
      _isAllTimeFilter = false;

      switch (period) {
        case 'today':
          _filterLabel = 'Aujourd\'hui';
          final now = DateTime.now();
          _filterStartDate = DateTime(now.year, now.month, now.day);
          _filterEndDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
          break;
        case 'thisMonth':
          _filterLabel = 'Ce mois';
          final now = DateTime.now();
          _filterStartDate = DateTime(now.year, now.month, 1);
          _filterEndDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
          break;
        case 'thisYear':
          _filterLabel = 'Cette année';
          final now = DateTime.now();
          _filterStartDate = DateTime(now.year, 1, 1);
          _filterEndDate = DateTime(now.year, 12, 31, 23, 59, 59);
          break;
        case 'allTime':
          _filterLabel = 'Tout le temps';
          _isAllTimeFilter = true; // Set the all time flag
          // Keep dates as null for all time
          break;
      }
    });
    _loadStatistics();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          PageHeader(title: AppStrings.statisticsTitle),
          StatisticsFilterSection(
            onFilter: _showFilterDialog,
            onClearFilter: _clearFilters,
            onQuickFilter: _handleQuickFilter,
            hasActiveFilters: _hasActiveFilters,
            customPeriodLabel: _filterLabel,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(AppDimensions.paddingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatsCards(),
                    SizedBox(height: AppDimensions.spaceL),
                    _buildChartsSection(),
                    SizedBox(height: AppDimensions.spaceL),
                    _buildActivityBreakdown(),
                    SizedBox(height: AppDimensions.spaceXXL),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildStatsCards() {
    if (_isLoading) {
      return _buildLoadingCards();
    }

    if (_errorMessage != null) {
      return _buildErrorCard();
    }

    final overview = _statistics?.overview;
    if (overview == null) {
      return _buildEmptyCard();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Total reservations as a simple phrase
        _buildTotalReservationsPhrase(overview.total),
        SizedBox(height: AppDimensions.spaceM),

        // Four status cards in a 2x2 grid
        LayoutBuilder(
          builder: (context, constraints) {
            // Calculate card width based on available space
            final cardWidth = (constraints.maxWidth - AppDimensions.spaceM) / 2;
            final cardHeight = cardWidth * 0.8; // Aspect ratio of 0.8

            return Wrap(
              spacing: AppDimensions.spaceM,
              runSpacing: AppDimensions.spaceM,
              children: [
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildStatCard(
                    AppStrings.pendingReservations,
                    '${overview.pending}',
                    Icons.schedule,
                    AppColors.chartYellow,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildStatCard(
                    AppStrings.confirmedReservations,
                    '${overview.confirmed}',
                    Icons.check_circle,
                    AppColors.chartBlue,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildStatCard(
                    AppStrings.paidReservations,
                    '${overview.paid}',
                    Icons.payment,
                    AppColors.chartOrange,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildStatCard(
                    AppStrings.cancelledReservations,
                    '${overview.cancelled}',
                    Icons.cancel,
                    AppColors.chartRed,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildTotalReservationsPhrase(int total) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_note,
            color: AppColors.primary,
            size: 18,
          ),
          SizedBox(width: AppDimensions.spaceS),
          RichText(
            text: TextSpan(
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimary,
              ),
              children: [
                TextSpan(text: 'Vous avez '),
                TextSpan(
                  text: '$total',
                  style: AppTextStyles.h5.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: total <= 1 ? ' réservation' : ' réservations',
                ),
                TextSpan(text: ' au total'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackWithOpacity(0.05),
            blurRadius: AppDimensions.elevationL,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(AppDimensions.paddingS),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppDimensions.spaceXS),
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackWithOpacity(0.05),
            blurRadius: AppDimensions.elevationL,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.reservationEvolution,
            style: AppTextStyles.h6.copyWith(color: AppColors.primary),
          ),
          SizedBox(height: AppDimensions.spaceM),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.show_chart,
                    size: 48,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: AppDimensions.spaceS),
                  Text(
                    AppStrings.chartPlaceholder,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityBreakdown() {
    if (_isLoading || _errorMessage != null || _statistics == null) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppDimensions.paddingL),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackWithOpacity(0.05),
              blurRadius: AppDimensions.elevationL,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.activityBreakdown,
              style: AppTextStyles.h6.copyWith(color: AppColors.primary),
            ),
            SizedBox(height: AppDimensions.spaceM),
            Center(
              child: Text(
                _isLoading ? 'Chargement...' : 'Aucune donnée disponible',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final activities = _statistics!.activities;
    final colors = [
      AppColors.chartGreen,
      AppColors.chartBlue,
      AppColors.chartOrange,
      AppColors.chartPurple,
      AppColors.chartRed,
      AppColors.primary,
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackWithOpacity(0.05),
            blurRadius: AppDimensions.elevationL,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.activityBreakdown,
            style: AppTextStyles.h6.copyWith(color: AppColors.primary),
          ),
          SizedBox(height: AppDimensions.spaceM),
          if (activities.isEmpty)
            Center(
              child: Text(
                'Aucune activité trouvée',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            )
          else
            ...activities.asMap().entries.map((entry) {
              final index = entry.key;
              final activity = entry.value;
              final color = colors[index % colors.length];
              
              return Padding(
                padding: EdgeInsets.only(bottom: AppDimensions.spaceS),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    SizedBox(width: AppDimensions.spaceM),
                    Expanded(
                      child: Text(
                        activity.activity,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${activity.count}',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  // Helper methods for different states
  Widget _buildLoadingCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Loading phrase placeholder
        _buildLoadingPhrase(),
        SizedBox(height: AppDimensions.spaceM),

        // Loading cards (4 cards in 2x2 grid)
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth - AppDimensions.spaceM) / 2;
            final cardHeight = cardWidth * 0.8;

            return Wrap(
              spacing: AppDimensions.spaceM,
              runSpacing: AppDimensions.spaceM,
              children: List.generate(4, (index) => SizedBox(
                width: cardWidth,
                height: cardHeight,
                child: Container(
                  padding: EdgeInsets.all(AppDimensions.paddingM),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blackWithOpacity(0.05),
                        blurRadius: AppDimensions.elevationL,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                ),
              )),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLoadingPhrase() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_note,
            color: AppColors.primary.withValues(alpha: 0.5),
            size: 18,
          ),
          SizedBox(width: AppDimensions.spaceS),
          Container(
            height: 20,
            width: 200,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackWithOpacity(0.05),
            blurRadius: AppDimensions.elevationL,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: AppDimensions.iconSize * 2,
            color: AppColors.error,
          ),
          SizedBox(height: AppDimensions.spaceM),
          Text(
            'Erreur de chargement',
            style: AppTextStyles.h6.copyWith(color: AppColors.error),
          ),
          SizedBox(height: AppDimensions.spaceS),
          Text(
            _errorMessage ?? 'Une erreur est survenue',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: AppDimensions.spaceL),
          ElevatedButton.icon(
            onPressed: _handleRefresh,
            icon: const Icon(Icons.refresh),
            label: const Text('Réessayer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackWithOpacity(0.05),
            blurRadius: AppDimensions.elevationL,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.analytics_outlined,
            size: AppDimensions.iconSize * 2,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: AppDimensions.spaceM),
          Text(
            'Aucune donnée disponible',
            style: AppTextStyles.h6.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: AppDimensions.spaceS),
          Text(
            'Aucune statistique trouvée pour la période sélectionnée',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}