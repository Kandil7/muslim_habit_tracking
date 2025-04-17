class PrayerItemModel {
  final String prayerImage, arName, enName, prayerTime;
  final Duration remainingTime;
  final bool isPrayerPassed;

  PrayerItemModel(
      {required this.prayerImage,
      required this.arName,
      required this.enName,
      required this.prayerTime,
      required this.remainingTime,
      required this.isPrayerPassed});
}
