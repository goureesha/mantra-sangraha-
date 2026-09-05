import sys
sys.stdout.reconfigure(encoding='utf-8')
"""
Build Data Pipeline: Markdown → JSON catalog + Flutter assets
Scans all book folders and generates:
  1. assets/data/books.json  — structured catalog
  2. assets/content/<book_id>/<file>.md — content files
"""
import os, json, shutil, re

BOOKS_DIR = os.path.join(os.path.dirname(__file__), '..', 'books')
ASSETS_DIR = os.path.join(os.path.dirname(__file__), 'assets')
CONTENT_DIR = os.path.join(ASSETS_DIR, 'content')
DATA_DIR = os.path.join(ASSETS_DIR, 'data')

BOOK_META = {
    '01_Mantra_Sangraha': {
        'id': 'mantra_sangraha',
        'title': 'ಮಂತ್ರ ಸಂಗ್ರಹ',
        'title_en': 'Mantra Sangraha',
        'description': 'A comprehensive 153-page Kannada compilation of mantras for Ganesha, Shiva, Devi, Vishnu, Saraswati, Navagraha and more.',
        'language': 'Kannada',
        'icon': 'om',
        'color': '#FF9933',
    },
    '02_Mantra_Mahodadhi': {
        'id': 'mantra_mahodadhi',
        'title': 'ಮಂತ್ರ ಮಹೋದಧಿ',
        'title_en': 'Mantra Mahodadhi',
        'description': 'Ocean of Mantras — 25 Tarangas covering Deeksha, Deities, Yantras, Shatkarma and Yajna procedures. Translated from Hindi to Kannada.',
        'language': 'Hindi → Kannada',
        'icon': 'waves',
        'color': '#1565C0',
    },
    '03_Mantra_Maharnava_Devi_Khanda': {
        'id': 'mantra_maharnava_devi_khanda',
        'title': 'ಮಂತ್ರ ಮಹಾರ್ಣವ (ದೇವೀ ಖಂಡ)',
        'title_en': 'Mantra Maharnava (Devi Khanda)',
        'description': 'Great Ocean of Mantras — Devi Section. 17 Tarangas covering all 10 Mahavidyas (Kali, Tara, Shodashi, Bhuvaneshwari, Bhairavi, Chhinnamasta, Dhumavati, Bagalamukhi, Matangi, Kamalatmika) and more. Translated from Hindi to Kannada.',
        'language': 'Hindi → Kannada',
        'icon': 'shakti',
        'color': '#C62828',
    },
}

# Files to skip (master combined files, READMEs)
SKIP_PATTERNS = ['Sampoorna', 'README']


def prettify_title(filename: str) -> str:
    """Convert filename to a readable chapter title."""
    name = os.path.splitext(filename)[0]
    # Remove leading number prefix like 00_, 01_, 02_
    name = re.sub(r'^\d+_', '', name)
    # Replace underscores with spaces
    name = name.replace('_', ' ')
    return name


def extract_kannada_title(filepath: str) -> str:
    """Extract the first H1 or H2 heading from the markdown file as title."""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            for line in f:
                line = line.strip()
                if line.startswith('# '):
                    return line.lstrip('# ').strip()
                if line.startswith('## '):
                    return line.lstrip('# ').strip()
    except:
        pass
    return ''


def build_catalog():
    os.makedirs(DATA_DIR, exist_ok=True)
    os.makedirs(CONTENT_DIR, exist_ok=True)

    books = []

    for folder_name, meta in BOOK_META.items():
        book_path = os.path.join(BOOKS_DIR, folder_name)
        if not os.path.isdir(book_path):
            print(f'WARNING: Book folder not found: {book_path}')
            continue

        book_id = meta['id']
        book_content_dir = os.path.join(CONTENT_DIR, book_id)
        os.makedirs(book_content_dir, exist_ok=True)

        # Collect chapter files
        md_files = sorted([
            f for f in os.listdir(book_path)
            if f.endswith('.md')
            and not any(skip in f for skip in SKIP_PATTERNS)
        ])

        chapters = []
        for order, md_file in enumerate(md_files):
            src = os.path.join(book_path, md_file)
            dst = os.path.join(book_content_dir, md_file)

            # Copy content file to assets
            shutil.copy2(src, dst)

            kannada_title = extract_kannada_title(src)
            en_title = prettify_title(md_file)

            file_size = os.path.getsize(src)

            chapters.append({
                'id': os.path.splitext(md_file)[0],
                'title': kannada_title if kannada_title else en_title,
                'title_en': en_title,
                'order': order,
                'file': f'{book_id}/{md_file}',
                'size_bytes': file_size,
            })

        book_entry = {
            **meta,
            'chapter_count': len(chapters),
            'chapters': chapters,
        }
        books.append(book_entry)
        print(f'  ✓ {meta["title_en"]}: {len(chapters)} chapters')

    catalog = {'books': books}

    catalog_path = os.path.join(DATA_DIR, 'books.json')
    with open(catalog_path, 'w', encoding='utf-8') as f:
        json.dump(catalog, f, ensure_ascii=False, indent=2)

    print(f'\n✓ Catalog written to {catalog_path}')
    print(f'✓ Content files copied to {CONTENT_DIR}')
    return catalog


if __name__ == '__main__':
    print('Building data catalog...\n')
    catalog = build_catalog()
    total_chapters = sum(b['chapter_count'] for b in catalog['books'])
    print(f'\nTotal: {len(catalog["books"])} books, {total_chapters} chapters')
