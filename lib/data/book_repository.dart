import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mantra_app/models/book.dart';

class BookRepository {
  List<Book>? _books;

  Future<List<Book>> getBooks() async {
    if (_books != null) return _books!;

    try {
      final jsonString = await rootBundle.loadString('assets/data/books.json');
      final jsonData = json.decode(jsonString);
      final booksList = jsonData['books'] as List;
      _books = booksList.map((bookJson) => Book.fromJson(bookJson)).toList();
      return _books!;
    } catch (e) {
      return [];
    }
  }

  Future<Book?> getBook(String id) async {
    final books = await getBooks();
    try {
      return books.firstWhere((book) => book.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<String> getChapterContent(String filePath) async {
    try {
      return await rootBundle.loadString('assets/content/$filePath');
    } catch (e) {
      return 'Content not found.';
    }
  }
}
