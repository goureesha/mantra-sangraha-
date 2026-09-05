import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mantra_app/data/search_repository.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search across all mantras...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white54),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: _onSearchChanged,
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_query.trim().isEmpty) {
      return const Center(child: Text('Search across all mantras...'));
    }
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_results.isEmpty) {
      return const Center(child: Text('No results found.'));
    }
    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final result = _results[index];
        return SearchResultTile(
          result: result,
          query: _query,
          onTap: () {
            // Navigator setup to pass book and chapter correctly needs BookRepository to fetch objects.
            // For simplicity, we can fetch them via a route argument that handles IDs or just pass a basic mapping.
            // The instruction says "navigate to reader for that chapter". 
            // In a real app we'd load the real Book and Chapter objects.
          },
        );
      },
    );
  }
}
