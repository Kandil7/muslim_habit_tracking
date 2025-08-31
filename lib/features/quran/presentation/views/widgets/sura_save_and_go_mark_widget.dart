import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/quran_bloc.dart';
import '../../bloc/quran_event.dart';

/// Widget for saving and navigating to markers in the Quran
class SuraSaveAndGoMarkWidget extends StatelessWidget {
  /// Current page index
  final int index;

  /// Constructor
  const SuraSaveAndGoMarkWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final quranBloc = context.read<QuranBloc>();
    final markerIndex = quranBloc.markerIndex;

    return Container(
      height: 150,
      width: double.infinity,
      color: Colors.black.withValues(alpha:0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                context,
                icon: Icons.bookmark_add,
                label: 'Save Marker',
                onPressed: () {
                  try {
                    quranBloc.add(SaveQuranMarkerEvent(position: index));
                    quranBloc.add(const ResetQuranViewStateEvent());
                  } catch (e) {
                    debugPrint('Error saving marker: $e');
                  }
                },
              ),
              if (markerIndex != null)
                _buildActionButton(
                  context,
                  icon: Icons.bookmark,
                  label: 'Go to Marker',
                  onPressed: () {
                    try {
                      quranBloc.add(
                        JumpToQuranPageEvent(pageNumber: markerIndex),
                      );
                      quranBloc.add(const ResetQuranViewStateEvent());
                    } catch (e) {
                      debugPrint('Error jumping to marker: $e');
                    }
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
