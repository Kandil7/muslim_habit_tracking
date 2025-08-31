import 'package:flutter/material.dart';
import 'package:muslim_habbit/features/enhanced_dashboard/presentation/bloc/enhanced_dashboard_state.dart';

/// Widget showing motivational snippets with Islamic content
class MotivationalSnippetWidget extends StatefulWidget {
  final MotivationalSnippet snippet;

  const MotivationalSnippetWidget({super.key, required this.snippet});

  @override
  State<MotivationalSnippetWidget> createState() => _MotivationalSnippetWidgetState();
}

class _MotivationalSnippetWidgetState extends State<MotivationalSnippetWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _getSnippetIcon(widget.snippet.type),
                const SizedBox(width: 8),
                const Text(
                  'Motivation',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSnippetContent(),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '- ${widget.snippet.source}',
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build snippet content with appropriate styling
  Widget _buildSnippetContent() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getBorderColor()),
      ),
      child: Text(
        widget.snippet.text,
        style: const TextStyle(
          fontSize: 16,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Get icon based on snippet type
  Widget _getSnippetIcon(String type) {
    IconData icon;
    Color color;
    
    switch (type) {
      case 'ayah':
        icon = Icons.menu_book;
        color = Colors.green;
        break;
      case 'hadith':
        icon = Icons.library_books;
        color = Colors.blue;
        break;
      case 'quote':
        icon = Icons.format_quote;
        color = Colors.purple;
        break;
      default:
        icon = Icons.lightbulb;
        color = Colors.orange;
    }
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color),
    );
  }

  /// Get background color based on snippet type
  Color _getBackgroundColor() {
    switch (widget.snippet.type) {
      case 'ayah':
        return Colors.green.withValues(alpha: 0.05);
      case 'hadith':
        return Colors.blue.withValues(alpha: 0.05);
      case 'quote':
        return Colors.purple.withValues(alpha: 0.05);
      default:
        return Colors.orange.withValues(alpha: 0.05);
    }
  }

  /// Get border color based on snippet type
  Color _getBorderColor() {
    switch (widget.snippet.type) {
      case 'ayah':
        return Colors.green.withValues(alpha: 0.3);
      case 'hadith':
        return Colors.blue.withValues(alpha: 0.3);
      case 'quote':
        return Colors.purple.withValues(alpha: 0.3);
      default:
        return Colors.orange.withValues(alpha: 0.3);
    }
  }
}