/// Single saved reflection (lesson reflection) for list/detail display.
class ReflectionEntity {
  const ReflectionEntity({
    required this.id,
    required this.lessonId,
    required this.reflectionText,
    this.lessonTitle,
    this.lessonDay,
    this.weekNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String lessonId;
  final String reflectionText;
  final String? lessonTitle;
  final int? lessonDay;
  final int? weekNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  static ReflectionEntity fromJson(Map<String, dynamic> json) {
    final createdAt = _parseDateTime(json['created_at']);
    final updatedAt = _parseDateTime(json['updated_at']);
    return ReflectionEntity(
      id: (json['id'] is num) ? (json['id'] as num).toInt() : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      lessonId: json['lesson_id']?.toString() ?? '',
      reflectionText: json['reflection_text'] as String? ?? '',
      lessonTitle: json['lesson_title'] as String?,
      lessonDay: json['lesson_day'] is num ? (json['lesson_day'] as num).toInt() : int.tryParse(json['lesson_day']?.toString() ?? ''),
      weekNumber: json['week_number'] is num ? (json['week_number'] as num).toInt() : int.tryParse(json['week_number']?.toString() ?? ''),
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}
