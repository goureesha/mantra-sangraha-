import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mantra_app/providers/bookmark_provider.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookmarkProvider>();
    final bookmarks = provider.bookmarks;

    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: bookmarks.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No bookmarks yet'),
                ],
              ),
            )
          : ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final bm = bookmarks[index];
                return Dismissible(
                  key: Key('${bm.bookId}_${bm.chapterId}'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    provider.toggleBookmark(bm.bookId, bm.chapterId, bm.chapterTitle, bm.bookTitle);
                  },
                  child: ListTile(
                    title: Text(bm.chapterTitle),
                    subtitle: Text(bm.bookTitle),
                    leading: const Icon(Icons.bookmark),
                    onTap: () {
                      // Navigate to reader
                    },
                  ),
                );
              },
            ),
    );
  }
}
