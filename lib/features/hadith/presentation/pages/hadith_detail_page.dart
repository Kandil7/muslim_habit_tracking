import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/localization/app_localizations_extension.dart';
import '../../domain/entities/hadith.dart';
import '../bloc/hadith_bloc.dart';
import '../bloc/hadith_event.dart';

/// Page displaying the details of a hadith
class HadithDetailPage extends StatelessWidget {
  /// The hadith to display
  final Hadith hadith;

  /// Creates a new HadithDetailPage
  const HadithDetailPage({super.key, required this.hadith});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.translate('hadith.title')),
        actions: [
          IconButton(
            icon: Icon(
              hadith.isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
              color: hadith.isBookmarked ? AppColors.primary : null,
            ),
            onPressed: () {
              context.read<HadithBloc>().add(
                ToggleHadithBookmarkEvent(id: hadith.id),
              );
            },
            tooltip:
                hadith.isBookmarked
                    ? context.tr.translate('hadith.hadithRemoved')
                    : context.tr.translate('hadith.hadithSaved'),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareHadith(context),
            tooltip: context.tr.translate('hadith.share'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hadith text
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.secondary.withAlpha(25),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.format_quote,
                    color: AppColors.secondary,
                    size: 24,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hadith.text,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          hadith.narrator,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Hadith details
            _buildDetailItem('Source', hadith.source),
            _buildDetailItem('Book', hadith.book),
            _buildDetailItem('Number', hadith.number),
            _buildDetailItem('Grade', hadith.grade),

            const SizedBox(height: 16),

            // Tags
            if (hadith.tags.isNotEmpty) ...[
              Text(
                context.tr.translate('hadith.tags'),
                style: AppTextStyles.headingSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    hadith.tags.map((tag) {
                      return Chip(
                        label: Text(tag),
                        backgroundColor: AppColors.secondary.withAlpha(25),
                      );
                    }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(child: Text(value, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }

  void _shareHadith(BuildContext context) {
    final String shareText = '''
"${hadith.text}"

Narrated by: ${hadith.narrator}
Source: ${hadith.source} ${hadith.number}
''';

    SharePlus.instance.share(ShareParams(text: shareText));
  }
}
