import '../models/motivational_quote.dart';

/// Repository for motivational quotes and Islamic teachings
class QuotesRepository {
  /// Get a list of all motivational quotes
  List<MotivationalQuote> getAllQuotes() {
    return _motivationalQuotes;
  }
  
  /// Get quotes filtered by tag
  List<MotivationalQuote> getQuotesByTag(String tag) {
    return _motivationalQuotes.where((quote) => quote.tags.contains(tag)).toList();
  }
  
  /// Get a random quote
  MotivationalQuote getRandomQuote() {
    _motivationalQuotes.shuffle();
    return _motivationalQuotes.first;
  }
  
  /// Get a random quote by tag
  MotivationalQuote? getRandomQuoteByTag(String tag) {
    final taggedQuotes = getQuotesByTag(tag);
    if (taggedQuotes.isEmpty) return null;
    
    taggedQuotes.shuffle();
    return taggedQuotes.first;
  }
  
  /// Get a quote for a specific habit type
  MotivationalQuote getQuoteForHabit(String habitType) {
    switch (habitType) {
      case 'prayer':
        return getRandomQuoteByTag('prayer') ?? getRandomQuote();
      case 'quran':
        return getRandomQuoteByTag('quran') ?? getRandomQuote();
      case 'fasting':
        return getRandomQuoteByTag('fasting') ?? getRandomQuote();
      case 'dhikr':
        return getRandomQuoteByTag('dhikr') ?? getRandomQuote();
      case 'charity':
        return getRandomQuoteByTag('charity') ?? getRandomQuote();
      default:
        return getRandomQuote();
    }
  }
  
  /// Collection of motivational quotes and Islamic teachings
  final List<MotivationalQuote> _motivationalQuotes = [
    // Quran Quotes
    const MotivationalQuote(
      id: 'q1',
      text: 'Indeed, with hardship comes ease.',
      arabicText: 'فَإِنَّ مَعَ الْعُسْرِ يُسْرًا',
      source: 'Quran',
      reference: 'Surah Ash-Sharh 94:5',
      tags: ['motivation', 'hardship', 'patience'],
    ),
    const MotivationalQuote(
      id: 'q2',
      text: 'And Allah is with the patient.',
      arabicText: 'وَاللَّهُ مَعَ الصَّابِرِينَ',
      source: 'Quran',
      reference: 'Surah Al-Anfal 8:66',
      tags: ['patience', 'motivation'],
    ),
    const MotivationalQuote(
      id: 'q3',
      text: 'So remember Me; I will remember you.',
      arabicText: 'فَاذْكُرُونِي أَذْكُرْكُمْ',
      source: 'Quran',
      reference: 'Surah Al-Baqarah 2:152',
      tags: ['dhikr', 'remembrance'],
    ),
    const MotivationalQuote(
      id: 'q4',
      text: 'And seek help through patience and prayer.',
      arabicText: 'وَاسْتَعِينُوا بِالصَّبْرِ وَالصَّلَاةِ',
      source: 'Quran',
      reference: 'Surah Al-Baqarah 2:45',
      tags: ['prayer', 'patience'],
    ),
    const MotivationalQuote(
      id: 'q5',
      text: 'Indeed, prayer prohibits immorality and wrongdoing.',
      arabicText: 'إِنَّ الصَّلَاةَ تَنْهَىٰ عَنِ الْفَحْشَاءِ وَالْمُنكَرِ',
      source: 'Quran',
      reference: 'Surah Al-Ankabut 29:45',
      tags: ['prayer', 'motivation'],
    ),
    
    // Hadith Quotes
    const MotivationalQuote(
      id: 'h1',
      text: 'The best of you are those who learn the Quran and teach it.',
      arabicText: 'خَيْرُكُمْ مَنْ تَعَلَّمَ الْقُرْآنَ وَعَلَّمَهُ',
      source: 'Hadith',
      reference: 'Sahih al-Bukhari 5027',
      tags: ['quran', 'knowledge'],
    ),
    const MotivationalQuote(
      id: 'h2',
      text: 'The most beloved deeds to Allah are those that are consistent, even if they are small.',
      arabicText: 'أَحَبُّ الْأَعْمَالِ إِلَى اللَّهِ أَدْوَمُهَا وَإِنْ قَلَّ',
      source: 'Hadith',
      reference: 'Sahih al-Bukhari 6464',
      tags: ['consistency', 'habits', 'motivation'],
    ),
    const MotivationalQuote(
      id: 'h3',
      text: 'Charity does not decrease wealth.',
      arabicText: 'مَا نَقَصَتْ صَدَقَةٌ مِنْ مَالٍ',
      source: 'Hadith',
      reference: 'Sahih Muslim 2588',
      tags: ['charity', 'wealth'],
    ),
    const MotivationalQuote(
      id: 'h4',
      text: 'Whoever fasts Ramadan out of faith and seeking reward, his previous sins will be forgiven.',
      arabicText: 'مَنْ صَامَ رَمَضَانَ إِيمَانًا وَاحْتِسَابًا غُفِرَ لَهُ مَا تَقَدَّمَ مِنْ ذَنْبِهِ',
      source: 'Hadith',
      reference: 'Sahih al-Bukhari 2014',
      tags: ['fasting', 'ramadan', 'forgiveness'],
    ),
    const MotivationalQuote(
      id: 'h5',
      text: 'The five daily prayers and the Friday prayer to the next Friday prayer are expiation for what is between them.',
      arabicText: 'الصَّلَوَاتُ الْخَمْسُ وَالْجُمْعَةُ إِلَى الْجُمْعَةِ كَفَّارَةٌ لِمَا بَيْنَهُنَّ',
      source: 'Hadith',
      reference: 'Sahih Muslim 233',
      tags: ['prayer', 'forgiveness'],
    ),
    
    // Prayer-specific quotes
    const MotivationalQuote(
      id: 'p1',
      text: 'Prayer is the pillar of religion.',
      arabicText: 'الصَّلَاةُ عِمَادُ الدِّينِ',
      source: 'Hadith',
      reference: 'Al-Bayhaqi',
      tags: ['prayer', 'importance'],
    ),
    const MotivationalQuote(
      id: 'p2',
      text: 'The first matter that the slave will be brought to account for on the Day of Judgment is the prayer.',
      arabicText: 'إِنَّ أَوَّلَ مَا يُحَاسَبُ بِهِ الْعَبْدُ يَوْمَ الْقِيَامَةِ الصَّلَاةُ',
      source: 'Hadith',
      reference: 'Sunan an-Nasa\'i 465',
      tags: ['prayer', 'accountability'],
    ),
    
    // Quran-specific quotes
    const MotivationalQuote(
      id: 'qr1',
      text: 'The one who is proficient in reciting the Quran will be with the honorable recording angels.',
      arabicText: 'الَّذِي يَقْرَأُ الْقُرْآنَ وَهُوَ مَاهِرٌ بِهِ مَعَ السَّفَرَةِ الْكِرَامِ الْبَرَرَةِ',
      source: 'Hadith',
      reference: 'Sahih al-Bukhari 4937',
      tags: ['quran', 'recitation'],
    ),
    const MotivationalQuote(
      id: 'qr2',
      text: 'Recite the Quran, for it will come as an intercessor for its companions on the Day of Resurrection.',
      arabicText: 'اقْرَءُوا الْقُرْآنَ فَإِنَّهُ يَأْتِي يَوْمَ الْقِيَامَةِ شَفِيعًا لِأَصْحَابِهِ',
      source: 'Hadith',
      reference: 'Sahih Muslim 804',
      tags: ['quran', 'intercession'],
    ),
    
    // Fasting-specific quotes
    const MotivationalQuote(
      id: 'f1',
      text: 'Fasting is a shield.',
      arabicText: 'الصَّوْمُ جُنَّةٌ',
      source: 'Hadith',
      reference: 'Sahih al-Bukhari 1894',
      tags: ['fasting', 'protection'],
    ),
    const MotivationalQuote(
      id: 'f2',
      text: 'Whoever fasts a day for the sake of Allah, Allah will distance his face from the Hellfire by seventy years.',
      arabicText: 'مَنْ صَامَ يَوْمًا فِي سَبِيلِ اللَّهِ بَاعَدَ اللَّهُ وَجْهَهُ عَنِ النَّارِ سَبْعِينَ خَرِيفًا',
      source: 'Hadith',
      reference: 'Sahih al-Bukhari 2840',
      tags: ['fasting', 'reward'],
    ),
    
    // Dhikr-specific quotes
    const MotivationalQuote(
      id: 'd1',
      text: 'The example of the one who remembers his Lord and the one who does not is like that of the living and the dead.',
      arabicText: 'مَثَلُ الَّذِي يَذْكُرُ رَبَّهُ وَالَّذِي لَا يَذْكُرُ رَبَّهُ مَثَلُ الْحَيِّ وَالْمَيِّتِ',
      source: 'Hadith',
      reference: 'Sahih al-Bukhari 6407',
      tags: ['dhikr', 'remembrance'],
    ),
    const MotivationalQuote(
      id: 'd2',
      text: 'There are two statements that are light on the tongue, heavy on the scales, and beloved to the Most Merciful: SubhanAllahi wa bihamdihi, SubhanAllahil Adheem.',
      arabicText: 'كَلِمَتَانِ خَفِيفَتَانِ عَلَى اللِّسَانِ ثَقِيلَتَانِ فِي الْمِيزَانِ حَبِيبَتَانِ إِلَى الرَّحْمَنِ سُبْحَانَ اللَّهِ وَبِحَمْدِهِ سُبْحَانَ اللَّهِ الْعَظِيمِ',
      source: 'Hadith',
      reference: 'Sahih al-Bukhari 6406',
      tags: ['dhikr', 'reward'],
    ),
    
    // Charity-specific quotes
    const MotivationalQuote(
      id: 'c1',
      text: 'The upper hand is better than the lower hand (the giving hand is better than the receiving hand).',
      arabicText: 'الْيَدُ الْعُلْيَا خَيْرٌ مِنَ الْيَدِ السُّفْلَى',
      source: 'Hadith',
      reference: 'Sahih al-Bukhari 1429',
      tags: ['charity', 'giving'],
    ),
    const MotivationalQuote(
      id: 'c2',
      text: 'Give charity without delay, for it stands in the way of calamity.',
      arabicText: 'بَادِرُوا بِالصَّدَقَةِ فَإِنَّ الْبَلَاءَ لَا يَتَخَطَّاهَا',
      source: 'Hadith',
      reference: 'Al-Bayhaqi',
      tags: ['charity', 'protection'],
    ),
    
    // General motivational quotes
    const MotivationalQuote(
      id: 'm1',
      text: 'Take advantage of five before five: your youth before your old age, your health before your sickness, your wealth before your poverty, your free time before your busyness, and your life before your death.',
      arabicText: 'اغْتَنِمْ خَمْسًا قَبْلَ خَمْسٍ: شَبَابَكَ قَبْلَ هَرَمِكَ، وَصِحَّتَكَ قَبْلَ سَقَمِكَ، وَغِنَاكَ قَبْلَ فَقْرِكَ، وَفَرَاغَكَ قَبْلَ شُغْلِكَ، وَحَيَاتَكَ قَبْلَ مَوْتِكَ',
      source: 'Hadith',
      reference: 'Al-Hakim',
      tags: ['time', 'motivation', 'life'],
    ),
    const MotivationalQuote(
      id: 'm2',
      text: 'He who treads a path in search of knowledge, Allah will make easy for him the path to Paradise.',
      arabicText: 'مَنْ سَلَكَ طَرِيقًا يَلْتَمِسُ فِيهِ عِلْمًا سَهَّلَ اللَّهُ لَهُ بِهِ طَرِيقًا إِلَى الْجَنَّةِ',
      source: 'Hadith',
      reference: 'Sahih Muslim 2699',
      tags: ['knowledge', 'motivation', 'learning'],
    ),
  ];
}
