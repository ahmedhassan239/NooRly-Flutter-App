# Noor Journey - Flutter App

A production-grade Flutter conversion of the Noor Journey Islamic spiritual journey app, featuring a complete design system, Clean Architecture, and comprehensive Islamic content.

## 🚀 Features

### ✅ Implemented
- **Complete Design System**: Colors, typography, spacing, shadows, and reusable components
- **Clean Architecture**: Domain-driven design with proper separation of concerns
- **Data Layer**: Local JSON data with repository pattern
- **Navigation**: Go Router with named routes and full web support
- **State Management**: Riverpod for reactive state management
- **Onboarding Flow**: Welcome, Shahada Date, Learning Goals, Journey Summary
- **Home Dashboard**: Daily tasks, prayer times, daily content, navigation cards
- **Duas Hub**: Search, categories, saved duas, detail view with Arabic/English content

### 🔄 In Progress
- Additional content hubs (Hadith, Verses, Adhkar)
- Lessons and learning journey
- Profile and settings screens
- Local persistence for favorites and progress
- Localization (EN/AR) with RTL support

## 🏗️ Architecture

### Clean Architecture Layers
```
lib/
├── core/           # App-wide utilities, themes, routers
├── design_system/  # Colors, typography, components, widgets
├── features/       # Feature-based modules
│   └── [feature]/
│       ├── domain/     # Entities, repositories, use cases
│       ├── data/       # Models, datasources, repositories
│       └── presentation/ # Pages, widgets, providers
└── l10n/           # Localization files
```

### Key Technologies
- **Flutter 3.10+**: Latest stable with Material 3
- **Riverpod**: Declarative state management
- **Go Router**: Type-safe navigation with named routes
- **Dio**: HTTP client (prepared for API integration)
- **Hive**: Local persistence (prepared for favorites/progress)
- **Freezed**: Code generation for models
- **Lucide Icons**: Consistent iconography

## 🌐 Flutter Web Routing

This app uses **PathUrlStrategy** for clean URLs (without `#`).

### URL Strategy
- ✅ Clean URLs: `/home`, `/duas`, `/lesson/5`
- ✅ Direct URL access works
- ✅ Browser refresh works
- ✅ Browser back/forward works

### Route Names (Type-Safe Navigation)

All routes have named identifiers for type-safe navigation:

```dart
import 'package:flutter_app/app/router.dart';

// Navigate by name (recommended)
context.goNamed(AppRoutes.home);
context.goNamed(AppRoutes.lessonDetail, pathParameters: {'dayNumber': '5'});
context.goNamed(AppRoutes.duasCategory, pathParameters: {'categoryId': 'morning'});

// Or by path (also works)
context.go('/home');
context.go('/lesson/5');
context.go('/duas/category/morning');
```

### Available Route Names

| Route Name | Path | Parameters |
|------------|------|------------|
| `AppRoutes.welcome` | `/` | - |
| `AppRoutes.shahadaDate` | `/onboarding/shahada-date` | - |
| `AppRoutes.learningGoals` | `/onboarding/goals` | - |
| `AppRoutes.journeySummary` | `/onboarding/summary` | - |
| `AppRoutes.home` | `/home` | - |
| `AppRoutes.journey` | `/journey` | - |
| `AppRoutes.journeySaved` | `/journey/saved` | - |
| `AppRoutes.lessonDetail` | `/lesson/:dayNumber` | `dayNumber` |
| `AppRoutes.prayerTimes` | `/prayer-times` | - |
| `AppRoutes.profile` | `/profile` | - |
| `AppRoutes.settings` | `/settings` | - |
| `AppRoutes.editProfile` | `/edit-profile` | - |
| `AppRoutes.duasHub` | `/duas` | - |
| `AppRoutes.duaDetail` | `/dua/:duaId` | `duaId` |
| `AppRoutes.duasCategory` | `/duas/category/:categoryId` | `categoryId` |
| `AppRoutes.duasSaved` | `/duas/saved` | - |
| `AppRoutes.hadithHub` | `/hadith` | - |
| `AppRoutes.hadithCategory` | `/hadith/category/:categoryId` | `categoryId` |
| `AppRoutes.hadithSaved` | `/hadith/saved` | - |
| `AppRoutes.versesHub` | `/verses` | - |
| `AppRoutes.versesCategory` | `/verses/category/:categoryId` | `categoryId` |
| `AppRoutes.versesSaved` | `/verses/saved` | - |
| `AppRoutes.adhkarHub` | `/adhkar` | - |
| `AppRoutes.adhkarCategory` | `/adhkar/category/:categoryId` | `categoryId` |
| `AppRoutes.adhkarSaved` | `/adhkar/saved` | - |
| `AppRoutes.notFound` | `/404` | - |

## 🖥️ Web Hosting Configuration

For **production deployment**, your web server must redirect all routes to `index.html` (SPA fallback).

### Nginx

```nginx
server {
    listen 80;
    server_name your-domain.com;
    root /var/www/noor-journey/build/web;
    index index.html;

    # SPA fallback - CRITICAL for Flutter Web routing
    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

Full config: `hosting/nginx.conf`

### Apache (.htaccess)

```apache
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule ^ index.html [L]
</IfModule>
```

Full config: `hosting/.htaccess`

### Firebase Hosting

```json
{
  "hosting": {
    "public": "build/web",
    "rewrites": [
      { "source": "**", "destination": "/index.html" }
    ]
  }
}
```

Full config: `hosting/firebase.json`

### Vercel

Create `vercel.json`:
```json
{
  "rewrites": [{ "source": "/(.*)", "destination": "/index.html" }]
}
```

### Netlify

Create `_redirects` in `build/web/`:
```
/*    /index.html   200
```

## 🎨 Design System

### Colors
- **Primary**: Deep Blue (#1E40AF) - Trust & Depth
- **Accent**: Coral (#FB923C) - CTAs & Motivation
- **Semantic**: Green (#10B981), Gold (#F59E0B), etc.
- **Neutrals**: Warm grays for comfortable reading

### Typography
- **Primary**: SF Pro Display (iOS-style)
- **Arabic**: Noto Sans Arabic with increased line height
- **Scale**: Display (32px) → H1 (24px) → Body (16px) → Caption (12px)

### Components
- `AppButton`: Multiple variants (primary, outline, etc.)
- `AppCard`: Consistent card styling with shadows
- `AppTextField`: Form inputs with validation
- `BottomNav`: Tab-based navigation
- `LibraryTabs`: Content hub navigation

## 📱 Screens Overview

### Route Mapping
| Web Route | Flutter Route | Screen Class | Status |
|-----------|---------------|--------------|--------|
| `/` | `/` | WelcomePage | ✅ Complete |
| `/onboarding/shahada-date` | `/onboarding/shahada-date` | ShahadaDatePage | ✅ Complete |
| `/onboarding/goals` | `/onboarding/goals` | LearningGoalPage | ✅ Complete |
| `/onboarding/summary` | `/onboarding/summary` | JourneySummaryPage | ✅ Complete |
| `/home` | `/home` | HomeDashboardPage | ✅ Complete |
| `/duas` | `/duas` | DuasHubPage | ✅ Complete |
| `/dua/:duaId` | `/dua/:duaId` | DuaDetailPage | ✅ Complete |
| `/journey` | `/journey` | LessonsListPage | 🔄 Placeholder |
| `/hadith` | `/hadith` | HadithHubPage | 🔄 Placeholder |
| `/verses` | `/verses` | VersesHubPage | 🔄 Placeholder |
| `/adhkar` | `/adhkar` | AdhkarHubPage | 🔄 Placeholder |

## 🗂️ Data Structure

### JSON Data Files (assets/data/)
- `duas.json`: Complete dua collection with categories
- `hadith.json`: Hadith collection (prepared)
- `verses.json`: Quran verses (prepared)
- `adhkar.json`: Daily adhkar (prepared)
- `lessons.json`: 90-day learning content (prepared)

### Data Flow
```
JSON Files → DataSource → Repository → Domain Entity → Presentation
```

## 🚀 Getting Started

### Prerequisites
- Flutter 3.10.0 or higher
- Dart 3.0.0 or higher
- Android Studio / Xcode for mobile development

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd mobile_app/flutter_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code (for freezed models)**
   ```bash
   flutter pub run build_runner build
   ```

### Running the App

#### Android
```bash
flutter run -d android
```

#### iOS
```bash
flutter run -d ios
```

#### Web (Chrome)
```bash
flutter run -d chrome
```

### Building for Production

#### Android APK
```bash
flutter build apk --release
```

#### iOS App Store
```bash
flutter build ios --release
```

#### Web
```bash
# Standard build
flutter build web --release

# Build for subpath deployment (e.g., /app/)
flutter build web --release --base-href /app/
```

## 🔧 Development

### Debug Logging

Router diagnostics are enabled in debug mode. Check console for:
```
[Router] Navigating to: /home
[Router] Full URI: /home
[Router] Path params: {}
[Router] Query params: {}
```

### Code Generation
```bash
# Watch for changes
flutter pub run build_runner watch

# Clean and regenerate
flutter pub run build_runner clean && flutter pub run build_runner build
```

### Adding New Features
1. Create feature directory: `lib/features/[feature_name]/`
2. Implement domain layer (entities, repositories)
3. Implement data layer (models, datasources)
4. Create presentation layer (pages, widgets, providers)
5. Add routes to `lib/app/router.dart` with unique name
6. Update providers in appropriate files

### Design System Usage
```dart
// Colors
Container(color: AppColors.primary)

// Typography
Text('Title', style: AppTypography.h1())

// Components
AppButton(
  text: 'Click me',
  onPressed: () => print('Pressed'),
  variant: AppButtonVariant.primary,
)
```

## 🌍 Localization

### Supported Languages
- **English (en)**: Default language
- **Arabic (ar)**: Prepared with RTL support

### Adding Languages
1. Add language code to `pubspec.yaml`
2. Create ARB files in `lib/l10n/arb/`
3. Run `flutter gen-l10n`
4. Use `AppLocalizations.of(context)!` in widgets

## 📊 State Management

### Riverpod Providers
```dart
// Read provider
final data = ref.watch(myProvider);

// Write to provider
ref.read(myProvider.notifier).updateData(newData);
```

### Local Persistence (Planned)
- **Favorites**: Hive boxes for saved content
- **Progress**: Learning progress and streaks
- **Settings**: User preferences and app state

## 🎯 Testing

### Widget Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test/
```

### Web Routing Test Checklist

| Test | Expected Result |
|------|-----------------|
| Start at `/` | Shows WelcomePage |
| Navigate to `/home` | Shows HomeDashboardPage |
| Navigate to `/lesson/5` | Shows Lesson 5 |
| Navigate to `/duas/category/morning` | Shows Morning Duas |
| Direct URL: `/home` | Shows HomeDashboardPage |
| Direct URL: `/lesson/10` | Shows Lesson 10 |
| Browser refresh on `/duas` | Stays on DuasHubPage |
| Invalid URL: `/xyz` | Shows NotFoundPage |

## 📦 Dependencies

### Core
- `flutter_riverpod`: State management
- `go_router`: Navigation
- `dio`: HTTP client

### UI & Animation
- `flutter_animate`: Smooth animations
- `lucide_icons`: Icon library
- `google_fonts`: Font loading

### Utilities
- `shared_preferences`: Simple key-value storage
- `overlay_support`: Toast notifications
- `gap`: Spacing utilities

## 🔒 Security & Privacy

- **No external APIs**: All data served locally
- **No user data collection**: App works offline
- **No analytics**: Privacy-focused design
- **Local storage only**: User preferences stored locally

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📄 License

This project is part of the Noor Journey Islamic app suite. See parent repository for licensing information.

## 🙏 Acknowledgments

- **Original React Design**: Converted with pixel-perfect accuracy
- **Islamic Content**: Sourced from authentic Islamic texts
- **Flutter Community**: For excellent documentation and packages
- **Material Design**: For design system foundation

---

**Built with ❤️ for the Muslim community**
