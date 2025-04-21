import 'package:flutter/material.dart';

import '../../domain/entities/quran_bookmark.dart';

/// Dialog for adding a bookmark
class AddBookmarkDialog extends StatefulWidget {
  /// Page number to bookmark
  final int pageNumber;

  /// Surah name (optional)
  final String? surahName;

  /// Ayah number (optional)
  final int? ayahNumber;

  /// Callback when a bookmark is added
  final Function(QuranBookmark) onBookmarkAdded;

  /// Constructor
  const AddBookmarkDialog({
    super.key,
    required this.pageNumber,
    this.surahName,
    this.ayahNumber,
    required this.onBookmarkAdded,
  });

  @override
  State<AddBookmarkDialog> createState() => _AddBookmarkDialogState();
}

class _AddBookmarkDialogState extends State<AddBookmarkDialog> {
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Set default title
    _titleController.text = widget.surahName != null
        ? 'Page ${widget.pageNumber} - ${widget.surahName}'
        : 'Page ${widget.pageNumber}';
  }

  @override
  void dispose() {
    _titleController.dispose();
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
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter a title for this bookmark',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Page: ${widget.pageNumber}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (widget.surahName != null) ...[
              const SizedBox(height: 8),
              Text(
                'Surah: ${widget.surahName}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
            if (widget.ayahNumber != null) ...[
              const SizedBox(height: 8),
              Text(
                'Ayah: ${widget.ayahNumber}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
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
                page: widget.pageNumber,
                surahName: widget.surahName,
                ayahNumber: widget.ayahNumber,
                title: _titleController.text,
                timestamp: DateTime.now(),
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
