import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/calendar_provider.dart';
import '../../../core/constants/app_spacing.dart';

/// Calendar widget with event markers for posts.
///
/// Features:
/// - Month view with navigation
/// - Color-coded markers by post status
/// - Today button
/// - Date selection
class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<CalendarProvider>();

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          // Header with month navigation and today button
          Container(
            padding: AppSpacing.paddingMD,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outlineVariant,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  _getMonthYearString(provider.focusedMonth),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                // Today button
                OutlinedButton.icon(
                  onPressed: provider.goToToday,
                  icon: const Icon(Icons.today, size: 18),
                  label: const Text('Today'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Calendar
          Padding(
            padding: AppSpacing.paddingMD,
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: provider.focusedMonth,
              selectedDayPredicate: (day) =>
                  isSameDay(provider.selectedDate, day),
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,

              // Event loader
              eventLoader: (day) => provider.getPostsForDate(day),

              // Header style
              headerVisible: false, // We use custom header above

              // Calendar style
              calendarStyle: CalendarStyle(
                // Today
                todayDecoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),

                // Selected day
                selectedDecoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),

                // Default day
                defaultTextStyle: TextStyle(
                  color: theme.colorScheme.onSurface,
                ),

                // Weekend
                weekendTextStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),

                // Outside month
                outsideTextStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),

                // Marker
                markerDecoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                markerSize: 6,
                markerMargin: const EdgeInsets.symmetric(horizontal: 0.5),
                markersMaxCount: 3,
              ),

              // Days of week style
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                weekendStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),

              // Callbacks
              onDaySelected: (selectedDay, focusedDay) {
                provider.selectDate(selectedDay);
              },

              onPageChanged: (focusedDay) {
                provider.setFocusedMonth(focusedDay);
              },

              // Custom marker builder for status-based colors
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isEmpty) return const SizedBox.shrink();

                  final statusCounts = provider.getStatusCountsForDate(date);
                  final markers = <Widget>[];

                  // Add markers for each status type
                  if (statusCounts['scheduled'] != null &&
                      statusCounts['scheduled']! > 0) {
                    markers.add(_buildMarker(theme.colorScheme.primary));
                  }
                  if (statusCounts['published'] != null &&
                      statusCounts['published']! > 0) {
                    markers.add(_buildMarker(Colors.green));
                  }
                  if (statusCounts['failed'] != null &&
                      statusCounts['failed']! > 0) {
                    markers.add(_buildMarker(theme.colorScheme.error));
                  }
                  if (statusCounts['draft'] != null &&
                      statusCounts['draft']! > 0) {
                    markers.add(
                      _buildMarker(theme.colorScheme.onSurfaceVariant),
                    );
                  }

                  // Limit to 3 markers
                  final displayMarkers = markers.take(3).toList();

                  return Positioned(
                    bottom: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: displayMarkers,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarker(Color color) {
    return Container(
      width: 6,
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 0.5),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  String _getMonthYearString(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
