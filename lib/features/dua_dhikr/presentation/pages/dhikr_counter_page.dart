import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/dhikr.dart';
import '../bloc/dua_dhikr_bloc.dart';
import '../bloc/dua_dhikr_event.dart';
import '../bloc/dua_dhikr_state.dart';

/// Page for counting dhikr repetitions
class DhikrCounterPage extends StatefulWidget {
  final Dhikr dhikr;

  const DhikrCounterPage({super.key, required this.dhikr});

  @override
  State<DhikrCounterPage> createState() => _DhikrCounterPageState();
}

class _DhikrCounterPageState extends State<DhikrCounterPage> with SingleTickerProviderStateMixin {
  int _count = 0;
  int _target = 0;
  bool _vibrationEnabled = true;
  bool _soundEnabled = true;
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _target = widget.dhikr.recommendedCount;
    _loadPreferences();
    
    // Setup animation for button press
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    
    _animation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _vibrationEnabled = prefs.getBool('dhikr_vibration_enabled') ?? true;
      _soundEnabled = prefs.getBool('dhikr_sound_enabled') ?? true;
    });
  }
  
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dhikr_vibration_enabled', _vibrationEnabled);
    await prefs.setBool('dhikr_sound_enabled', _soundEnabled);
  }
  
  void _incrementCount() {
    setState(() {
      _count++;
    });
    
    // Provide haptic feedback if enabled
    if (_vibrationEnabled) {
      HapticFeedback.lightImpact();
    }
    
    // Play sound if enabled
    if (_soundEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
    
    // Animate button press
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    
    // Show completion dialog when target is reached
    if (_count == _target) {
      _showCompletionDialog();
    }
  }
  
  void _resetCount() {
    setState(() {
      _count = 0;
    });
  }
  
  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Target Reached!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'You have completed ${widget.dhikr.recommendedCount} repetitions of:',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              widget.dhikr.title,
              style: AppTextStyles.headingSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Continue'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _resetCount();
            },
            child: const Text('Reset Counter'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dhikr.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Dhikr information
          Container(
            padding: const EdgeInsets.all(20),
            color: AppColors.primary,
            width: double.infinity,
            child: Column(
              children: [
                Text(
                  widget.dhikr.title,
                  style: AppTextStyles.headingMedium.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Target: ${widget.dhikr.recommendedCount} times',
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withOpacity(0.8)),
                ),
              ],
            ),
          ),
          
          // Arabic text
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              widget.dhikr.arabicText,
              style: AppTextStyles.arabicText.copyWith(fontSize: 28),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ),
          
          // Transliteration
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              widget.dhikr.transliteration,
              style: AppTextStyles.bodyMedium.copyWith(fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ),
          
          // Translation
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              widget.dhikr.translation,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          
          const Spacer(),
          
          // Counter display
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  '$_count / $_target',
                  style: AppTextStyles.headingLarge.copyWith(
                    color: _count >= _target ? AppColors.success : AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: _target > 0 ? _count / _target : 0,
                  minHeight: 10,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _count >= _target ? AppColors.success : AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          
          // Counter button
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Reset button
                IconButton(
                  onPressed: _resetCount,
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Reset Counter',
                ),
                
                const SizedBox(width: 16),
                
                // Main counter button
                Expanded(
                  child: GestureDetector(
                    onTap: _incrementCount,
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _animation.value,
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.touch_app,
                                color: Colors.white,
                                size: 48,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Favorite button
                IconButton(
                  onPressed: () {
                    context.read<DuaDhikrBloc>().add(
                      ToggleDhikrFavoriteEvent(id: widget.dhikr.id),
                    );
                  },
                  icon: Icon(
                    widget.dhikr.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: widget.dhikr.isFavorite ? AppColors.secondary : null,
                  ),
                  tooltip: 'Toggle Favorite',
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }
  
  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Counter Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Vibration'),
              subtitle: const Text('Haptic feedback when counting'),
              value: _vibrationEnabled,
              onChanged: (value) {
                setState(() {
                  _vibrationEnabled = value;
                });
                _savePreferences();
              },
            ),
            SwitchListTile(
              title: const Text('Sound'),
              subtitle: const Text('Click sound when counting'),
              value: _soundEnabled,
              onChanged: (value) {
                setState(() {
                  _soundEnabled = value;
                });
                _savePreferences();
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _target.toString(),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Target Count',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                final target = int.tryParse(value);
                if (target != null && target > 0) {
                  setState(() {
                    _target = target;
                  });
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
