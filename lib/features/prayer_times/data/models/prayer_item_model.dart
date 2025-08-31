class PrayerItemModel {
  final String prayerImage, arName, enName, prayerTime;
  Duration remainingTime; // Changed from final to allow updates
  bool isPrayerPassed; // Changed from final to allow updates

  PrayerItemModel({
    required this.prayerImage,
    required this.arName,
    required this.enName,
    required this.prayerTime,
    required this.remainingTime,
    required this.isPrayerPassed,
  });
}
