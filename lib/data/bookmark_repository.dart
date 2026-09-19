import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mantra_app/models/bookmark.dart';

class BookmarkRepository {
  static const String _key = 'bookmarks_list';

  Future<int> addBookmark(Bookmark bookmark) async {
    final bookmarks = await getBookmarks();
    bookmarks.add(bookmark);
    await _save(bookmarks);
    return bookmarks.length;
  }

  Future<int> removeBookmark(String bookId, String chapterId) async {
    final bookmarks = await getBookmarks();
    bookmarks.removeWhere((b) => b.bookId == bookId && b.chapterId == chapterId);
    await _save(bookmarks);
    return 1;
  }

  Future<List<Bookmark>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    final List<dynamic> list = json.decode(jsonStr);
    return list.map((m) => Bookmark.fromMap(Map<String, dynamic>.from(m))).toList();
  }

  Future<bool> isBookmarked(String bookId, String chapterId) async {
    final bookmarks = await getBookmarks();
    return bookmarks.any((b) => b.bookId == bookId && b.chapterId == chapterId);
  }

  Future<void> _save(List<Bookmark> bookmarks) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = json.encode(bookmarks.map((b) => b.toMap()).toList());
    await prefs.setString(_key, jsonStr);
  }
}
