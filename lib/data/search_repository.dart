import 'package:mantra_app/data/book_repository.dart';

class SearchResult {
  final String bookId;
  final String bookTitle;
  final String chapterId;
  final String chapterTitle;
  final String matchedLine;
  final int lineNumber;

  const SearchResult({
    required this.bookId,
    required this.bookTitle,
    required this.chapterId,
    required this.chapterTitle,
    required this.matchedLine,
    required this.lineNumber,
  });
}

class SearchRepository {
  final BookRepository bookRepository;

  SearchRepository(this.bookRepository);

  Future<List<SearchResult>> search(String query) async {
    if (query.trim().isEmpty) return [];
    final lowerQuery = query.toLowerCase();
    final results = <SearchResult>[];

    final books = await bookRepository.getBooks();
    for (var book in books) {
      for (var chapter in book.chapters) {
        final content = await bookRepository.getChapterContent(chapter.file);
        final lines = content.split('\n');
        for (int i = 0; i < lines.length; i++) {
          if (lines[i].toLowerCase().contains(lowerQuery)) {
            results.add(SearchResult(
              bookId: book.id,
              bookTitle: book.title,
              chapterId: chapter.id,
              chapterTitle: chapter.title,
              matchedLine: lines[i].trim(),
              lineNumber: i + 1,
            ));
          }
        }
      }
    }
    return results;
  }
}
