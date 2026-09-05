import 'package:flutter/material.dart';
import 'package:mantra_app/data/search_repository.dart';

class SearchResultTile extends StatelessWidget {
  final SearchResult result;
  final String query;
  final VoidCallback onTap;

  const SearchResultTile({
    super.key,
    required this.result,
    required this.query,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Highlight the search query in the matched line
    final lowerLine = result.matchedLine.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final matchIndex = lowerLine.indexOf(lowerQuery);

    List<TextSpan> spans = [];
    if (matchIndex >= 0) {
      if (matchIndex > 0) {
        spans.add(TextSpan(text: result.matchedLine.substring(0, matchIndex)));
      }
      spans.add(TextSpan(
        text: result.matchedLine.substring(matchIndex, matchIndex + query.length),
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ));
      if (matchIndex + query.length < result.matchedLine.length) {
        spans.add(TextSpan(text: result.matchedLine.substring(matchIndex + query.length)));
      }
    } else {
      spans.add(TextSpan(text: result.matchedLine));
    }

    return ListTile(
      leading: const Icon(Icons.search),
      title: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyLarge,
          children: spans,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text('${result.bookTitle} > ${result.chapterTitle}'),
      onTap: onTap,
    );
  }
}
