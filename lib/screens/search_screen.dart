import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mantra_app/data/book_repository.dart';
import 'package:mantra_app/data/search_repository.dart';
import 'package:mantra_app/models/book.dart';
import 'package:mantra_app/widgets/search_result_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  List<SearchResult> _results = [];
  bool _isLoading = false;
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    setState(() {
      _query = query;
      if (query.trim().isEmpty) {
        _results = [];
        _isLoading = false;
      } else {
        _isLoading = true;
      }
    });

    if (query.trim().isNotEmpty) {
      _debounce = Timer(const Duration(milliseconds: 300), () async {
        final repo = context.read<SearchRepository>();
        final results = await repo.search(query);
        if (mounted) {
          setState(() {
            _results = results;
            _isLoading = false;
          });
        }
      });
    }
  }

  Future<void> _navigateToChapter(SearchResult result) async {
    final bookRepo = context.read<BookRepository>();
    final book = await bookRepo.getBook(result.bookId);
    if (book == null || !mounted) return;
    final chapter = book.chapters.firstWhere(
      (c) => c.id == result.chapterId,
      orElse: () => book.chapters.first,
    );
    if (!mounted) return;
    Navigator.pushNamed(context, '/reader', arguments: {
      'book': book,
      'chapter': chapter,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Search across all mantras...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
            ),
            onChanged: _onSearchChanged,
          ),
        ),
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildBody() {
    if (_query.trim().isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Search across all mantras...'),
          ],
        ),
      );
    }
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_results.isEmpty) {
      return const Center(child: Text('No results found.'));
    }
    return ListView.builder(
      itemCount: _results.length > 50 ? 50 : _results.length,
      itemBuilder: (context, index) {
        final result = _results[index];
        return SearchResultTile(
          result: result,
          query: _query,
          onTap: () => _navigateToChapter(result),
        );
      },
    );
  }
}
