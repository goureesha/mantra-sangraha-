import 'package:flutter/material.dart';
import 'package:mantra_app/data/bookmark_repository.dart';
import 'package:mantra_app/models/bookmark.dart';

class BookmarkProvider with ChangeNotifier {
  final BookmarkRepository _repository;
  List<Bookmark> _bookmarks = [];

  BookmarkProvider(this._repository) {
    _loadBookmarks();
  }

  List<Bookmark> get bookmarks => _bookmarks;

  Future<void> _loadBookmarks() async {
    _bookmarks = await _repository.getBookmarks();
    notifyListeners();
  }

  Future<void> toggleBookmark(String bookId, String chapterId, String chapterTitle, String bookTitle) async {
    final isMarked = await _repository.isBookmarked(bookId, chapterId);
    if (isMarked) {
      await _repository.removeBookmark(bookId, chapterId);
    } else {
      await _repository.addBookmark(Bookmark(
        bookId: bookId,
        chapterId: chapterId,
        chapterTitle: chapterTitle,
        bookTitle: bookTitle,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ));
    }
    await _loadBookmarks();
  }

  Future<bool> isBookmarked(String bookId, String chapterId) async {
    return await _repository.isBookmarked(bookId, chapterId);
  }
}
