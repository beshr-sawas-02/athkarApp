class DailyStats {
  final String date; // yyyy-MM-dd
  final int totalCounts;
  final Map<String, int> perThikr; // thikrId -> counts that day
  final String? topThikrId;
  final String? topThikrName;

  DailyStats({
    required this.date,
    this.totalCounts = 0,
    Map<String, int>? perThikr,
    this.topThikrId,
    this.topThikrName,
  }) : perThikr = perThikr ?? {};

  Map<String, dynamic> toJson() => {
        'date': date,
        'totalCounts': totalCounts,
        'perThikr': perThikr,
        'topThikrId': topThikrId,
        'topThikrName': topThikrName,
      };

  factory DailyStats.fromJson(Map<String, dynamic> json) {
    final raw = json['perThikr'];
    final map = <String, int>{};
    if (raw is Map) {
      raw.forEach((k, v) => map[k.toString()] = (v as num).toInt());
    }
    return DailyStats(
      date: json['date'] as String,
      totalCounts: (json['totalCounts'] as num?)?.toInt() ?? 0,
      perThikr: map,
      topThikrId: json['topThikrId'] as String?,
      topThikrName: json['topThikrName'] as String?,
    );
  }

  DailyStats copyWith({
    String? date,
    int? totalCounts,
    Map<String, int>? perThikr,
    String? topThikrId,
    String? topThikrName,
  }) =>
      DailyStats(
        date: date ?? this.date,
        totalCounts: totalCounts ?? this.totalCounts,
        perThikr: perThikr ?? Map<String, int>.from(this.perThikr),
        topThikrId: topThikrId ?? this.topThikrId,
        topThikrName: topThikrName ?? this.topThikrName,
      );
}
