import '../models/unlockable_content_model.dart';

/// Predefined unlockable content for the app
class PredefinedUnlockableContent {
  /// List of predefined unlockable content
  static final List<UnlockableContentModel> content = [
    // Motivational Quotes
    const UnlockableContentModel(
      id: 'quote_1',
      name: 'Perseverance Quote',
      description: 'A motivational quote about perseverance in worship',
      contentType: 'quote',
      contentPath: 'assets/quotes/perseverance.json',
      pointsRequired: 50,
      previewPath: 'assets/images/previews/quote_preview.png',
    ),
    const UnlockableContentModel(
      id: 'quote_2',
      name: 'Patience Quote',
      description: 'A motivational quote about patience in hardship',
      contentType: 'quote',
      contentPath: 'assets/quotes/patience.json',
      pointsRequired: 75,
      previewPath: 'assets/images/previews/quote_preview.png',
    ),
    const UnlockableContentModel(
      id: 'quote_3',
      name: 'Gratitude Quote',
      description: 'A motivational quote about being grateful to Allah',
      contentType: 'quote',
      contentPath: 'assets/quotes/gratitude.json',
      pointsRequired: 100,
      previewPath: 'assets/images/previews/quote_preview.png',
    ),
    
    // Dua Cards
    const UnlockableContentModel(
      id: 'dua_1',
      name: 'Morning Duas',
      description: 'Collection of morning duas with translations',
      contentType: 'dua',
      contentPath: 'assets/duas/morning.json',
      pointsRequired: 150,
      previewPath: 'assets/images/previews/dua_preview.png',
    ),
    const UnlockableContentModel(
      id: 'dua_2',
      name: 'Evening Duas',
      description: 'Collection of evening duas with translations',
      contentType: 'dua',
      contentPath: 'assets/duas/evening.json',
      pointsRequired: 150,
      previewPath: 'assets/images/previews/dua_preview.png',
    ),
    const UnlockableContentModel(
      id: 'dua_3',
      name: 'Travel Duas',
      description: 'Collection of duas for travel with translations',
      contentType: 'dua',
      contentPath: 'assets/duas/travel.json',
      pointsRequired: 200,
      previewPath: 'assets/images/previews/dua_preview.png',
    ),
    
    // Wallpapers
    const UnlockableContentModel(
      id: 'wallpaper_1',
      name: 'Kaaba Wallpaper',
      description: 'Beautiful wallpaper of the Kaaba',
      contentType: 'wallpaper',
      contentPath: 'assets/wallpapers/kaaba.jpg',
      pointsRequired: 250,
      previewPath: 'assets/images/previews/wallpaper_preview.png',
    ),
    const UnlockableContentModel(
      id: 'wallpaper_2',
      name: 'Masjid Nabawi Wallpaper',
      description: 'Beautiful wallpaper of Masjid Nabawi',
      contentType: 'wallpaper',
      contentPath: 'assets/wallpapers/masjid_nabawi.jpg',
      pointsRequired: 250,
      previewPath: 'assets/images/previews/wallpaper_preview.png',
    ),
    const UnlockableContentModel(
      id: 'wallpaper_3',
      name: 'Ramadan Wallpaper',
      description: 'Beautiful Ramadan-themed wallpaper',
      contentType: 'wallpaper',
      contentPath: 'assets/wallpapers/ramadan.jpg',
      pointsRequired: 300,
      previewPath: 'assets/images/previews/wallpaper_preview.png',
    ),
    
    // Special Features
    const UnlockableContentModel(
      id: 'feature_1',
      name: 'Custom Themes',
      description: 'Unlock additional app themes',
      contentType: 'feature',
      contentPath: 'custom_themes',
      pointsRequired: 500,
      previewPath: 'assets/images/previews/feature_preview.png',
    ),
    const UnlockableContentModel(
      id: 'feature_2',
      name: 'Advanced Analytics',
      description: 'Unlock advanced habit analytics',
      contentType: 'feature',
      contentPath: 'advanced_analytics',
      pointsRequired: 750,
      previewPath: 'assets/images/previews/feature_preview.png',
    ),
  ];
}
