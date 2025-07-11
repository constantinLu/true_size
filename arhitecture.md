# Project Structure:

lib/
├── app/
│   ├── app.dart                 # Main app configuration
│   ├── app.router.dart          # Generated routes
│   └── app.locator.dart         # Service locator
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_sizes.dart
│   ├── enums/
│   │   └── measurement_type.dart
│   ├── models/
│   │   ├── measurement_entry.dart
│   │   ├── measurement_item.dart
│   │   └── user_model.dart
│   ├── services/
│   │   ├── auth_service.dart
│   │   ├── firestore_service.dart
│   │   └── navigation_service.dart
│   └── utils/
│       ├── validators.dart
│       └── helpers.dart
├── ui/
│   ├── common/
│   │   ├── app_colors.dart
│   │   ├── ui_helpers.dart
│   │   └── widgets/
│   │       ├── custom_card.dart
│   │       ├── measurement_tag.dart
│   │       ├── search_bar.dart
│   │       └── loading_indicator.dart
│   ├── views/
│   │   ├── startup/
│   │   │   ├── startup_view.dart
│   │   │   └── startup_viewmodel.dart
│   │   ├── login/
│   │   │   ├── login_view.dart
│   │   │   └── login_viewmodel.dart
│   │   ├── home/
│   │   │   ├── home_view.dart
│   │   │   └── home_viewmodel.dart
│   │   ├── measurement_detail/
│   │   │   ├── measurement_detail_view.dart
│   │   │   └── measurement_detail_viewmodel.dart
│   │   └── add_measurement/
│   │       ├── add_measurement_view.dart
│   │       └── add_measurement_viewmodel.dart
│   └── responsive/
│       ├── orientation_layout.dart
│       └── sizing_information.dart
└── main.dart

# Key Features Implementation:

## 1. Authentication with Firebase
- Google Sign-In integration
- User session management
- Secure token handling

## 2. Stacked Architecture
- MVVM pattern with ViewModels
- Reactive state management
- Service-based dependency injection

## 3. Responsive Design
- Responsive builder for different screen sizes
- Adaptive layouts for mobile and tablet
- Orientation-aware UI components

## 4. Data Models
- MeasurementEntry: Main entry container (shoes, body, etc.)
- MeasurementItem: Individual measurements within entry
- Tag system for categorization and search
- Brand-specific measurements support

## 5. Firebase Integration
- Firestore for data persistence
- Real-time synchronization
- Offline support
- User-specific data isolation

## 6. Search & Filter
- Tag-based search (#sports, #elegant)
- Brand-specific filtering
- Text-based search across all measurements
- Recent searches and suggestions