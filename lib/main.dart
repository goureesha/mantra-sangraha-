import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mantra_app/data/bookmark_repository.dart';
import 'package:mantra_app/data/book_repository.dart';
import 'package:mantra_app/data/search_repository.dart';
import 'package:mantra_app/providers/bookmark_provider.dart';
import 'package:mantra_app/providers/font_provider.dart';
import 'package:mantra_app/providers/theme_provider.dart';
import 'package:mantra_app/theme/app_theme.dart';
import 'package:mantra_app/screens/home_screen.dart';
import 'package:mantra_app/screens/book_detail_screen.dart';
import 'package:mantra_app/screens/reader_screen.dart';
import 'package:mantra_app/screens/search_screen.dart';
import 'package:mantra_app/screens/bookmarks_screen.dart';
import 'package:mantra_app/screens/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FontProvider()),
        Provider(create: (_) => BookRepository()),
        ProxyProvider<BookRepository, SearchRepository>(
          update: (_, bookRepo, __) => SearchRepository(bookRepo),
        ),
        Provider(create: (_) => BookmarkRepository()),
        ChangeNotifierProxyProvider<BookmarkRepository, BookmarkProvider>(
          create: (context) => BookmarkProvider(context.read<BookmarkRepository>()),
          update: (_, repo, previous) => previous ?? BookmarkProvider(repo),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    
    ThemeData theme;
    switch (themeProvider.themeName) {
      case 'light':
        theme = AppTheme.lightTheme();
        break;
      case 'dark':
        theme = AppTheme.darkTheme();
        break;
      case 'temple':
      default:
        theme = AppTheme.templeTheme();
    }

    return MaterialApp(
      title: 'Mantra Sangraha',
      theme: theme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/book': (context) => const BookDetailScreen(),
        '/reader': (context) => const ReaderScreen(),
        '/search': (context) => const SearchScreen(),
        '/bookmarks': (context) => const BookmarksScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
