import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:mantra_app/models/bookmark.dart';

class BookmarkRepository {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bookmarks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE bookmarks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bookId TEXT NOT NULL,
        chapterId TEXT NOT NULL,
        chapterTitle TEXT NOT NULL,
        bookTitle TEXT NOT NULL,
        createdAt INTEGER NOT NULL
      )
    ''');
  }

  Future<int> addBookmark(Bookmark bookmark) async {
    final db = await database;
    return await db.insert('bookmarks', bookmark.toMap());
  }

  Future<int> removeBookmark(String bookId, String chapterId) async {
    final db = await database;
    return await db.delete(
      'bookmarks',
      where: 'bookId = ? AND chapterId = ?',
      whereArgs: [bookId, chapterId],
    );
  }

  Future<List<Bookmark>> getBookmarks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'bookmarks',
      orderBy: 'createdAt DESC',
    );
    return maps.map((map) => Bookmark.fromMap(map)).toList();
  }

  Future<bool> isBookmarked(String bookId, String chapterId) async {
    final db = await database;
    final maps = await db.query(
      'bookmarks',
      where: 'bookId = ? AND chapterId = ?',
      whereArgs: [bookId, chapterId],
    );
    return maps.isNotEmpty;
  }
}
