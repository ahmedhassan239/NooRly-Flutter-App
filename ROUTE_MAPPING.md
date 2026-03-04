# Route Mapping Table

## Web Route → Flutter Route → Flutter Screen Class → Notes

### Onboarding Flow
| Web Route | Flutter Route | Flutter Screen Class | Status | Notes |
|-----------|---------------|---------------------|--------|-------|
| `/` | `/` | `WelcomePage` | ✅ Complete | Onboarding step 0 |
| `/onboarding/shahada-date` | `/onboarding/shahada-date` | `ShahadaDatePage` | ✅ Complete | Stepper UI with date picker |
| `/onboarding/goals` | `/onboarding/goals` | `LearningGoalPage` | ✅ Complete | Goal selection |
| `/onboarding/summary` | `/onboarding/summary` | `JourneySummaryPage` | ✅ Complete | Journey overview |

### Main App
| Web Route | Flutter Route | Flutter Screen Class | Status | Notes |
|-----------|---------------|---------------------|--------|-------|
| `/home` | `/home` | `HomeDashboardPage` | 🟡 Partial | Needs full implementation |
| `/journey` | `/journey` | `LessonsListPage` | ❌ TODO | Lessons list with week/day structure |
| `/journey/saved` | `/journey/saved` | `SavedLessonsPage` | ❌ TODO | Saved lessons list |
| `/lesson/:dayNumber` | `/lesson/:dayNumber` | `LessonDetailPage` | ❌ TODO | Dynamic route with dayNumber param |
| `/prayer-times` | `/prayer-times` | `PrayerTimesPage` | ❌ TODO | Prayer times with countdown |
| `/profile` | `/profile` | `ProfilePage` | ❌ TODO | User profile view |
| `/settings` | `/settings` | `SettingsPage` | ❌ TODO | App settings |
| `/edit-profile` | `/edit-profile` | `EditProfilePage` | ❌ TODO | Edit user profile |

### Duas
| Web Route | Flutter Route | Flutter Screen Class | Status | Notes |
|-----------|---------------|---------------------|--------|-------|
| `/duas` | `/duas` | `DuasHubPage` | ✅ Complete | Hub with categories and search |
| `/dua/:duaId` | `/dua/:duaId` | `DuaDetailPage` | ❌ TODO | Dua detail with actions |
| `/duas/category/:categoryId` | `/duas/category/:categoryId` | `CategoryDuasListPage` | ❌ TODO | Category duas list |
| `/duas/saved` | `/duas/saved` | `SavedDuasPage` | ❌ TODO | Saved duas list |

### Hadith
| Web Route | Flutter Route | Flutter Screen Class | Status | Notes |
|-----------|---------------|---------------------|--------|-------|
| `/hadith` | `/hadith` | `HadithHubPage` | ❌ TODO | Hub with categories and search |
| `/hadith/category/:categoryId` | `/hadith/category/:categoryId` | `CategoryHadithListPage` | ❌ TODO | Category hadith list |
| `/hadith/saved` | `/hadith/saved` | `SavedHadithPage` | ❌ TODO | Saved hadith list |

### Verses
| Web Route | Flutter Route | Flutter Screen Class | Status | Notes |
|-----------|---------------|---------------------|--------|-------|
| `/verses` | `/verses` | `VersesHubPage` | ❌ TODO | Hub with categories and search |
| `/verses/category/:categoryId` | `/verses/category/:categoryId` | `CategoryVersesListPage` | ❌ TODO | Category verses list |
| `/verses/saved` | `/verses/saved` | `SavedVersesPage` | ❌ TODO | Saved verses list |

### Adhkar
| Web Route | Flutter Route | Flutter Screen Class | Status | Notes |
|-----------|---------------|---------------------|--------|-------|
| `/adhkar` | `/adhkar` | `AdhkarHubPage` | ❌ TODO | Hub with categories and search |
| `/adhkar/category/:categoryId` | `/adhkar/category/:categoryId` | `CategoryAdhkarListPage` | ❌ TODO | Category adhkar list |
| `/adhkar/saved` | `/adhkar/saved` | `SavedAdhkarPage` | ❌ TODO | Saved adhkar list |

### Error Handling
| Web Route | Flutter Route | Flutter Screen Class | Status | Notes |
|-----------|---------------|---------------------|--------|-------|
| `*` (catch-all) | `*` | `NotFoundPage` | ✅ Complete | 404 fallback route |

## Legend
- ✅ Complete: Fully implemented with UI parity
- 🟡 Partial: Basic structure exists, needs completion
- ❌ TODO: Not yet implemented

## Total Routes: 25
- Complete: 5
- Partial: 1
- TODO: 19
