import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:mantra_app/models/book.dart';
import 'package:mantra_app/data/book_repository.dart';
import 'package:mantra_app/providers/font_provider.dart';
import 'package:mantra_app/providers/bookmark_provider.dart';
import 'package:mantra_app/widgets/japa_counter.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({super.key});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  final ScrollController _scrollController = ScrollController();
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        final max = _scrollController.position.maxScrollExtent;
        final current = _scrollController.offset;
        setState(() {
          _progress = max > 0 ? (current / max).clamp(0.0, 1.0) : 0.0;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final book = args['book'] as Book;
    final chapter = args['chapter'] as Chapter;
    
    final repo = context.read<BookRepository>();
    final fontProvider = context.watch<FontProvider>();
    final bookmarkProvider = context.watch<BookmarkProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(chapter.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.text_decrease),
            onPressed: fontProvider.decrement,
          ),
          IconButton(
            icon: const Icon(Icons.text_increase),
            onPressed: fontProvider.increment,
          ),
          FutureBuilder<bool>(
            future: bookmarkProvider.isBookmarked(book.id, chapter.id),
            builder: (context, snapshot) {
              final isMarked = snapshot.data ?? false;
              return IconButton(
                icon: Icon(isMarked ? Icons.bookmark : Icons.bookmark_border),
                onPressed: () {
                  bookmarkProvider.toggleBookmark(book.id, chapter.id, chapter.title, book.title);
                },
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: _progress,
            backgroundColor: theme.colorScheme.surfaceVariant,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
      body: FutureBuilder<String>(
        future: repo.getChapterContent(chapter.file),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Failed to load content'));
          }

          final content = snapshot.data!;
          final baseStyle = theme.textTheme.bodyLarge!.copyWith(
            fontSize: theme.textTheme.bodyLarge!.fontSize! * fontProvider.fontScale,
          );

          return SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0),
            child: MarkdownBody(
              data: content,
              styleSheet: MarkdownStyleSheet(
                p: baseStyle,
                h1: theme.textTheme.headlineLarge!.copyWith(
                  color: theme.colorScheme.primary,
                  fontSize: theme.textTheme.headlineLarge!.fontSize! * fontProvider.fontScale,
                ),
                h2: theme.textTheme.headlineMedium!.copyWith(
                  color: theme.colorScheme.primary,
                  fontSize: theme.textTheme.headlineMedium!.fontSize! * fontProvider.fontScale,
                ),
                h3: theme.textTheme.headlineSmall!.copyWith(
                  color: theme.colorScheme.primary,
                  fontSize: theme.textTheme.headlineSmall!.fontSize! * fontProvider.fontScale,
                ),
                blockquoteDecoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  border: Border(
                    left: BorderSide(color: theme.colorScheme.primary, width: 4),
                  ),
                ),
                blockquotePadding: const EdgeInsets.all(16.0),
                blockquote: baseStyle.copyWith(color: theme.colorScheme.onSurface),
                code: baseStyle.copyWith(
                  fontFamily: 'monospace',
                  backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const JapaCounter(),
          );
        },
        child: const Icon(Icons.fingerprint),
      ),
    );
  }
}
