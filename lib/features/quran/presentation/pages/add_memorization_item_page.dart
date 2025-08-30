import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_item.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_preferences.dart';
import 'package:muslim_habbit/features/quran/presentation/bloc/memorization/memorization_bloc.dart';
import 'package:quran_library/quran_library.dart';
import 'package:uuid/uuid.dart';

/// Page for adding a new memorization item
class AddMemorizationItemPage extends StatefulWidget {
  const AddMemorizationItemPage({super.key});

  @override
  State<AddMemorizationItemPage> createState() => _AddMemorizationItemPageState();
}

class _AddMemorizationItemPageState extends State<AddMemorizationItemPage> {
  final _formKey = GlobalKey<FormState>();
  late List<Surah> _sortedSurahs;
  Surah? _selectedSurah;
  int _startPage = 1;
  int _endPage = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSurahs();
  }

  /// Load surahs and sort them based on user preferences
  Future<void> _loadSurahs() async {
    setState(() {
      _isLoading = true;
    });

    // Get the Quran library instance
    final quranLibrary = QuranLibrary();
    
    // Load all surahs
    final allSurahs = await quranLibrary.getAllSurahs();
    
    // Get user preferences to determine sorting order
    final preferencesState = context.read<MemorizationBloc>().state;
    if (preferencesState is MemorizationPreferencesLoaded) {
      final preferences = preferencesState.preferences;
      if (preferences.memorizationDirection == MemorizationDirection.fromNas) {
        // Sort from Nas (114) to Baqarah (2)
        _sortedSurahs = List.from(allSurahs)..sort((a, b) => b.number.compareTo(a.number));
      } else {
        // Sort from Baqarah (2) to Nas (114)
        _sortedSurahs = List.from(allSurahs)..sort((a, b) => a.number.compareTo(b.number));
      }
    } else {
      // Default to from Baqarah
      _sortedSurahs = List.from(allSurahs)..sort((a, b) => a.number.compareTo(b.number));
    }
    
    // Load preferences if not already loaded
    context.read<MemorizationBloc>().add(LoadMemorizationPreferences());
    
    setState(() {
      _isLoading = false;
    });
  }

  /// Handle form submission
  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedSurah != null) {
      final newItem = MemorizationItem(
        id: const Uuid().v4(),
        surahNumber: _selectedSurah!.number,
        surahName: _selectedSurah!.name,
        startPage: _startPage,
        endPage: _endPage,
        dateAdded: DateTime.now(),
        status: MemorizationStatus.newStatus,
        consecutiveReviewDays: 0,
        lastReviewed: null,
        reviewHistory: [],
      );

      context.read<MemorizationBloc>().add(CreateMemorizationItemEvent(newItem));
      
      // Show success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Memorization item added successfully!')),
      );
      
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Memorization Item'),
      ),
      body: BlocListener<MemorizationBloc, MemorizationState>(
        listener: (context, state) {
          if (state is MemorizationOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Memorization item added successfully!')),
            );
            Navigator.pop(context);
          } else if (state is MemorizationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select a Surah',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  DropdownButtonFormField<Surah>(
                    value: _selectedSurah,
                    hint: const Text('Select a Surah'),
                    items: _sortedSurahs.map((surah) {
                      return DropdownMenuItem<Surah>(
                        value: surah,
                        child: Text('${surah.number}. ${surah.name}'),
                      );
                    }).toList(),
                    onChanged: (Surah? newValue) {
                      setState(() {
                        _selectedSurah = newValue;
                        if (newValue != null) {
                          _startPage = newValue.pages.first;
                          _endPage = newValue.pages.last;
                        }
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a surah';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 24),
                const Text(
                  'Page Range',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Start Page',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _startPage.toString(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter start page';
                          }
                          final page = int.tryParse(value);
                          if (page == null || page < 1 || page > 604) {
                            return 'Please enter a valid page number (1-604)';
                          }
                          if (_selectedSurah != null && 
                              (page < _selectedSurah!.pages.first || 
                               page > _selectedSurah!.pages.last)) {
                            return 'Page must be within surah range (${_selectedSurah!.pages.first}-${_selectedSurah!.pages.last})';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          final page = int.tryParse(value);
                          if (page != null) {
                            setState(() {
                              _startPage = page;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'End Page',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _endPage.toString(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter end page';
                          }
                          final page = int.tryParse(value);
                          if (page == null || page < 1 || page > 604) {
                            return 'Please enter a valid page number (1-604)';
                          }
                          if (_selectedSurah != null && 
                              (page < _selectedSurah!.pages.first || 
                               page > _selectedSurah!.pages.last)) {
                            return 'Page must be within surah range (${_selectedSurah!.pages.first}-${_selectedSurah!.pages.last})';
                          }
                          if (page < _startPage) {
                            return 'End page must be greater than or equal to start page';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          final page = int.tryParse(value);
                          if (page != null) {
                            setState(() {
                              _endPage = page;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Instructions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'This surah will be added as a "New" item. Review it daily for 5 consecutive days to make it "Memorized".',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Add to Memorization List'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}