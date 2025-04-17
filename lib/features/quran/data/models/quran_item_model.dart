class QuranItemModel {
  final String arName, enName, arType, enType;
  final int verses, start;

  QuranItemModel(
      {required this.arName,
      required this.enName,
      required this.arType,
      required this.enType,
      required this.verses,
      required this.start});

  factory QuranItemModel.fromJson(json) {
    return QuranItemModel(
        arName: json['arName'],
        enName: json['enName'],
        arType: json['arType'],
        enType: json['enType'],
        verses: json['verses'],
        start: json['start']);
  }
}
