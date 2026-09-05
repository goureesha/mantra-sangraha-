class Bookmark {
  final int? id;
  final String bookId;
  final String chapterId;
  final String chapterTitle;
  final String bookTitle;
  final int createdAt;

  const Bookmark({
    this.id,
    required this.bookId,
    required this.chapterId,
    required this.chapterTitle,
    required this.bookTitle,
    required this.createdAt,
  });

  factory Bookmark.fromMap(Map<String, dynamic> map) {
    return Bookmark(
      id: map['id'] as int?,
      bookId: map['bookId'] as String,
      chapterId: map['chapterId'] as String,
      chapterTitle: map['chapterTitle'] as String,
      bookTitle: map['bookTitle'] as String,
      createdAt: map['createdAt'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookId': bookId,
      'chapterId': chapterId,
      'chapterTitle': chapterTitle,
      'bookTitle': bookTitle,
      'createdAt': createdAt,
    };
  }

  factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark.fromMap(json);
  Map<String, dynamic> toJson() => toMap();
}
