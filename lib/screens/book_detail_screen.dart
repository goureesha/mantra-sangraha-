import 'package:flutter/material.dart';
import 'package:mantra_app/models/book.dart';
import 'package:mantra_app/widgets/chapter_tile.dart';

class BookDetailScreen extends StatelessWidget {
  const BookDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final book = ModalRoute.of(context)!.settings.arguments as Book;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(book.title),
              background: Container(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: Center(
                  child: Hero(
                    tag: 'book_icon_${book.id}',
                    child: Icon(
                      _getIcon(book.icon),
                      size: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                book.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final chapter = book.chapters[index];
                return ChapterTile(
                  chapter: chapter,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/reader',
                      arguments: {'book': book, 'chapter': chapter},
                    );
                  },
                );
              },
              childCount: book.chapters.length,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'om':
        return Icons.auto_awesome;
      case 'waves':
        return Icons.waves;
      case 'shakti':
        return Icons.auto_awesome;
      default:
        return Icons.book;
    }
  }
}
