# 🙏 Mantra Sangraha — ಮಂತ್ರ ಸಂಗ್ರಹ

A beautiful, offline-first Flutter app for reading sacred mantras, shlokas, and tantra texts in Kannada with original Sanskrit verses.

## 📚 Content

| Book | Language | Chapters |
|------|----------|----------|
| **ಮಂತ್ರ ಸಂಗ್ರಹ** (Mantra Sangraha) | Kannada | 8 chapters |
| **ಮಂತ್ರ ಮಹೋದಧಿ** (Mantra Mahodadhi) | Hindi → Kannada | 27 chapters |
| **ಮಂತ್ರ ಮಹಾರ್ಣವ ದೇವೀ ಖಂಡ** (Mantra Maharnava Devi Khanda) | Hindi → Kannada | 19 chapters |

## ✨ Features

- 📖 **3 books, 54 chapters** of mantras and shlokas
- 🔍 **Full-text search** across all books
- 🔖 **Bookmarks** — save your favorite mantras
- 📿 **Japa Counter** — digital 108/1008 mala counter
- 🎨 **Temple Theme** — saffron/gold dark theme, plus light & dark options
- 🔤 **Adjustable font size** — read comfortably
- 📴 **100% Offline** — no internet required

## 🚀 Getting Started

### Build with GitHub Actions (Recommended)

1. Push this repo to GitHub
2. GitHub Actions will automatically build the APK
3. Download the APK from the Actions tab → Artifacts

### Build Locally

```bash
flutter pub get
flutter build apk --release
```

The APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

## 📁 Project Structure

```
mantra_app/
├── .github/workflows/build.yml   # CI/CD — auto builds APK
├── assets/
│   ├── data/books.json            # Book catalog
│   └── content/                   # Markdown content files
├── lib/
│   ├── main.dart                  # App entry point
│   ├── models/                    # Book, Chapter, Bookmark
│   ├── data/                      # Repositories (data loading, search, bookmarks)
│   ├── providers/                 # State management (theme, font, bookmarks)
│   ├── screens/                   # 6 app screens
│   ├── widgets/                   # Reusable UI components
│   └── theme/                     # Temple, dark, light themes
├── android/                       # Android platform config
└── pubspec.yaml                   # Flutter dependencies
```

## 📱 Screens

| Screen | Description |
|--------|-------------|
| **Home** | Book library grid with beautiful cards |
| **Book Detail** | Chapter list for a selected book |
| **Reader** | Markdown mantra reader with shloka styling |
| **Search** | Full-text search across all books |
| **Bookmarks** | Saved mantras |
| **Settings** | Theme, font size, about |

## 🎨 Themes

- **Temple** (default) — Deep maroon with saffron/gold accents
- **Dark** — Standard dark theme
- **Light** — Warm cream with maroon accents

## 🛠️ Adding New Books

1. Add markdown files to `books/` folder
2. Update `BOOK_META` in `build_data.py`
3. Run `python build_data.py` to regenerate assets
4. Push and rebuild
