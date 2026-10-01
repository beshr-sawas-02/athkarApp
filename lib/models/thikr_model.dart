import 'thikr_category.dart';

class Thikr {
  final String id;
  final String name;
  final int goal;
  int count;
  bool goalReached;
  final bool isDefault;
  final DateTime createdAt;
  final ThikrCategory category;

  Thikr({
    required this.id,
    required this.name,
    required this.goal,
    this.count = 0,
    this.goalReached = false,
    this.isDefault = false,
    DateTime? createdAt,
    this.category = ThikrCategory.general,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'goal': goal,
        'count': count,
        'goalReached': goalReached,
        'isDefault': isDefault,
        'createdAt': createdAt.toIso8601String(),
        'category': category.name,
      };

  factory Thikr.fromJson(Map<String, dynamic> json) => Thikr(
        id: json['id'],
        name: json['name'],
        goal: json['goal'],
        count: json['count'] ?? 0,
        goalReached: json['goalReached'] ?? false,
        isDefault: json['isDefault'] ?? false,
        createdAt: DateTime.parse(json['createdAt']),
        category: ThikrCategory.fromName(json['category'] as String?),
      );

  Thikr copyWith({
    String? id,
    String? name,
    int? goal,
    int? count,
    bool? goalReached,
    bool? isDefault,
    DateTime? createdAt,
    ThikrCategory? category,
  }) =>
      Thikr(
        id: id ?? this.id,
        name: name ?? this.name,
        goal: goal ?? this.goal,
        count: count ?? this.count,
        goalReached: goalReached ?? this.goalReached,
        isDefault: isDefault ?? this.isDefault,
        createdAt: createdAt ?? this.createdAt,
        category: category ?? this.category,
      );
}
