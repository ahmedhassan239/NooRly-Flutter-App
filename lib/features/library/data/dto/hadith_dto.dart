/// DTO for a hadith item in collection details (API: text, text_ar, text_en, etc.).
library;

class HadithDto {
  const HadithDto({
    required this.id,
    required this.text,
    this.textAr,
    this.textEn,
    this.collectionName,
    this.hadithNumber,
    this.chapterNumber,
  });

  final int id;
  final String text;
  final String? textAr;
  final String? textEn;
  final String? collectionName;
  final dynamic hadithNumber;
  final dynamic chapterNumber;

  static HadithDto fromJson(Map<String, dynamic> json) {
    return HadithDto(
      id: (json['id'] as num).toInt(),
      text: json['text'] as String? ?? '',
      textAr: json['text_ar'] as String?,
      textEn: json['text_en'] as String?,
      collectionName: json['collection_name'] as String?,
      hadithNumber: json['hadith_number'],
      chapterNumber: json['chapter_number'],
    );
  }
}
