import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/prayer_time.dart';

/// Widget to display prayer times for a day
class PrayerTimeCard extends StatelessWidget {
  final PrayerTime prayerTime;
  final VoidCallback? onSetReminder;

  /// Creates a new PrayerTimeCard
  const PrayerTimeCard({
    super.key,
    required this.prayerTime,
    this.onSetReminder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final nextPrayer = prayerTime.getNextPrayer();
    final currentPrayer = prayerTime.getCurrentPrayer();
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('EEEE, MMMM d, yyyy').format(prayerTime.date),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Next prayer
            if (nextPrayer.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Next Prayer',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                nextPrayer.keys.first,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                DateFormat('h:mm a').format(nextPrayer.values.first),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getTimeUntil(nextPrayer.values.first),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Current prayer
            if (currentPrayer != null && currentPrayer.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.mosque,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Prayer',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSecondaryContainer.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            currentPrayer.keys.first,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 16),
            
            // All prayer times
            ..._buildPrayerTimesList(context),
            
            const SizedBox(height: 16),
            
            // Set reminder button
            if (onSetReminder != null)
              OutlinedButton.icon(
                onPressed: onSetReminder,
                icon: const Icon(Icons.notifications),
                label: const Text('Set Reminders'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  List<Widget> _buildPrayerTimesList(BuildContext context) {
    final theme = Theme.of(context);
    final allPrayers = prayerTime.getAllPrayers();
    final now = DateTime.now();
    
    return allPrayers.entries.map((entry) {
      final prayerName = entry.key;
      final time = entry.value;
      final isNext = prayerTime.getNextPrayer().keys.first == prayerName;
      final isCurrent = prayerTime.getCurrentPrayer()?.keys.first == prayerName;
      
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isNext
                    ? theme.colorScheme.primary
                    : isCurrent
                        ? theme.colorScheme.secondary
                        : theme.colorScheme.onSurface.withOpacity(0.3),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                prayerName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isNext || isCurrent ? FontWeight.bold : null,
                  color: isNext
                      ? theme.colorScheme.primary
                      : isCurrent
                          ? theme.colorScheme.secondary
                          : null,
                ),
              ),
            ),
            Text(
              DateFormat('h:mm a').format(time),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isNext || isCurrent ? FontWeight.bold : null,
                color: isNext
                    ? theme.colorScheme.primary
                    : isCurrent
                        ? theme.colorScheme.secondary
                        : null,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
  
  String _getTimeUntil(DateTime time) {
    final now = DateTime.now();
    final difference = time.difference(now);
    
    if (difference.isNegative) {
      return 'Passed';
    }
    
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    
    if (hours > 0) {
      return '$hours hour${hours > 1 ? 's' : ''} $minutes minute${minutes > 1 ? 's' : ''} remaining';
    } else {
      return '$minutes minute${minutes > 1 ? 's' : ''} remaining';
    }
  }
}
