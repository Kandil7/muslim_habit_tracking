class HizbModel {
  final int surah;
  int hizbQuarter;
  int get hizb => (hizbQuarter / 4).fixedRound;
  int get juz => (hizbQuarter / 8).fixedRound;

  HizbModel({required this.surah, required this.hizbQuarter});
}

extension Round on double {
  int get fixedRound {
    if (this == roundToDouble()) return toInt();
    return toInt() + 1;
  }
}
