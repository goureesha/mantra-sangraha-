import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mantra_app/data/book_repository.dart';
import 'package:mantra_app/providers/bookmark_provider.dart';
import 'package:mantra_app/models/bookmark.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookmarkProvider = context.watch<BookmarkProvider>();
    final bookmarks = bookmarkProvider.bookmarks;

    if (bookmarks.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No bookmarks yet'),
            SizedBox(height: 8),
            Text('Bookmark mantras while reading', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: bookmarks.length,
      itemBuilder: (context, index) {
        final bookmark = bookmarks[index];
        return Dismissible(
          key: Key('${bookmark.bookId}_${bookmark.chapterId}'),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) {
            bookmarkProvider.toggleBookmark(
              bookmark.bookId, bookmark.chapterId,
              bookmark.chapterTitle, bookmark.bookTitle,
            );
          },
          child: Card(
            child: ListTile(
              leading: const Icon(Icons.bookmark),
              title: Text(bookmark.chapterTitle),
              subtitle: Text(bookmark.bookTitle),
              onTap: () async {
                final bookRepo = context.read<BookRepository>();
                final book = await bookRepo.getBook(bookmark.bookId);
                if (book == null || !context.mounted) return;
                final chapter = book.chapters.firstWhere(
                  (c) => c.id == bookmark.chapterId,
                  orElse: () => book.chapters.first,
                );
                if (!context.mounted) return;
                Navigator.pushNamed(context, '/reader', arguments: {
                  'book': book,
                  'chapter': chapter,
                });
              },
            ),
          ),
        );
      },
    );
  }
}
