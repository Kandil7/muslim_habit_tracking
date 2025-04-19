import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/quran_reading_history.dart';
import '../bloc/quran_bloc.dart';
import '../bloc/quran_event.dart';

/// Widget to track Quran reading time and save history
class QuranReadingTracker extends StatefulWidget {
  /// The page number being read
  final int pageNumber;
  
  /// The surah number (optional)
  final int? surahNumber;
  
  /// The surah name (optional)
  final String? surahName;
  
  /// The ayah number (optional)
  final int? ayahNumber;

  /// Constructor
  const QuranReadingTracker({
    Key? key,
    required this.pageNumber,
    this.surahNumber,
    this.surahName,
    this.ayahNumber,
  }) : super(key: key);

  @override
  State<QuranReadingTracker> createState() => _QuranReadingTrackerState();
}

class _QuranReadingTrackerState extends State<QuranReadingTracker> {
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isTracking = false;

  @override
  void initState() {
    super.initState();
    _startTracking();
  }

  @override
  void dispose() {
    _stopTracking(saveHistory: true);
    super.dispose();
  }

  void _startTracking() {
    setState(() {
      _isTracking = true;
      _elapsedSeconds = 0;
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
    
    // Save the last read position
    _saveLastReadPosition();
  }

  void _stopTracking({bool saveHistory = false}) {
    _timer?.cancel();
    
    setState(() {
      _isTracking = false;
    });
    
    if (saveHistory && _elapsedSeconds > 5) {
      // Only save history if reading time is more than 5 seconds
      _saveReadingHistory();
    }
  }

  void _saveLastReadPosition() {
    final history = QuranReadingHistory(
      id: DateTime.now().millisecondsSinceEpoch,
      surahNumber: widget.surahNumber,
      surahName: widget.surahName,
      ayahNumber: widget.ayahNumber,
      pageNumber: widget.pageNumber,
      timestamp: DateTime.now(),
    );
    
    context.read<QuranBloc>().add(UpdateLastReadPositionEvent(history: history));
  }

  void _saveReadingHistory() {
    final history = QuranReadingHistory(
      id: DateTime.now().millisecondsSinceEpoch,
      surahNumber: widget.surahNumber,
      surahName: widget.surahName,
      ayahNumber: widget.ayahNumber,
      pageNumber: widget.pageNumber,
      timestamp: DateTime.now(),
      durationSeconds: _elapsedSeconds,
    );
    
    context.read<QuranBloc>().add(AddReadingHistoryEvent(history: history));
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.timer, size: 16),
        const SizedBox(width: 4),
        Text(_formatTime(_elapsedSeconds)),
        const SizedBox(width: 8),
        if (_isTracking)
          IconButton(
            icon: const Icon(Icons.pause),
            onPressed: () => _stopTracking(saveHistory: true),
            iconSize: 16,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          )
        else
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: _startTracking,
            iconSize: 16,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
      ],
    );
  }
}
