import 'package:flutter/material.dart';
import 'package:mantra_app/models/book.dart';

class ChapterTile extends StatelessWidget {
  final Chapter chapter;
  final VoidCallback onTap;

  const ChapterTile({
    super.key,
    required this.chapter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        foregroundColor: Theme.of(context).colorScheme.primary,
        child: Text('${chapter.order + 1}'),
      ),
      title: Text(chapter.title),
      subtitle: Text(chapter.titleEn),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
