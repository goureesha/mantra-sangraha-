class Book {
  final String id;
  final String title;
  final String titleEn;
  final String description;
  final String icon;
  final String color;
  final int chapterCount;
  final List<Chapter> chapters;

  const Book({
    required this.id,
    required this.title,
    required this.titleEn,
    required this.description,
    required this.icon,
    required this.color,
    required this.chapterCount,
    required this.chapters,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    var chaptersList = json['chapters'] as List? ?? [];
    List<Chapter> chapters = chaptersList.map((c) => Chapter.fromJson(c)).toList();
    
    return Book(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      titleEn: json['title_en'] as String? ?? '',
      description: json['description'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      color: json['color'] as String? ?? '',
      chapterCount: json['chapter_count'] as int? ?? 0,
      chapters: chapters,
    );
  }
}

class Chapter {
  final String id;
  final String title;
  final String titleEn;
  final int order;
  final String file;
  final int sizeBytes;

  const Chapter({
    required this.id,
    required this.title,
    required this.titleEn,
    required this.order,
    required this.file,
    required this.sizeBytes,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      titleEn: json['title_en'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      file: json['file'] as String? ?? '',
      sizeBytes: json['size_bytes'] as int? ?? 0,
    );
  }
}
