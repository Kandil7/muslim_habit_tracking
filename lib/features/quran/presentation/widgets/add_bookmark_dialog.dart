import 'package:flutter/material.dart';

import '../../domain/entities/quran_bookmark.dart';

/// Dialog to add a new Quran bookmark
class AddBookmarkDialog extends StatefulWidget {
  /// The page number to bookmark
  final int pageNumber;

  /// The surah name (optional)
  final String? surahName;

  /// The ayah number (optional)
  final int? ayahNumber;

  /// The ayah ID (optional)
  final int? ayahId;

  /// Callback when a bookmark is added
  final Function(QuranBookmark bookmark) onBookmarkAdded;

  /// Constructor
  const AddBookmarkDialog({
    super.key,
    required this.pageNumber,
    required this.onBookmarkAdded,
    this.surahName,
    this.ayahNumber,
    this.ayahId,
  });

  @override
  State<AddBookmarkDialog> createState() => _AddBookmarkDialogState();
}

class _AddBookmarkDialogState extends State<AddBookmarkDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  Color _selectedColor = Colors.blue;

  final List<Color> _bookmarkColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
  ];

  @override
  void initState() {
    super.initState();
    // Set default name based on surah name if available
    if (widget.surahName != null) {
      _nameController.text = 'Surah ${widget.surahName}';
      if (widget.ayahNumber != null) {
        _nameController.text += ' - Ayah ${widget.ayahNumber}';
      }
    } else {
      _nameController.text = 'Page ${widget.pageNumber}';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Bookmark'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Bookmark Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name for the bookmark';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Text('Choose a color:'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  _bookmarkColors.map((color) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = color;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                _selectedColor == color
                                    ? Colors.black
                                    : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final bookmark = QuranBookmark(
                id: DateTime.now().millisecondsSinceEpoch,
                surahName: widget.surahName,
                ayahNumber: widget.ayahNumber,
                ayahId: widget.ayahId,
                page: widget.pageNumber,
                colorCode:
                    (_selectedColor.r.toInt() << 16) |
                    (_selectedColor.g.toInt() << 8) |
                    _selectedColor.b.toInt(),
                name: _nameController.text,
              );

              widget.onBookmarkAdded(bookmark);
              Navigator.of(context).pop(true);
            }
          },
          child: const Text('ADD'),
        ),
      ],
    );
  }
}
