# SunnahTrack - Muslim Habit Tracker

SunnahTrack is a visually appealing, Islamic-themed habit tracker to help Muslims build and maintain consistent worship practices (e.g., prayers, Quran recitation, fasting, dhikr) while adhering to Clean Architecture principles for scalability.

## Features

### Habit Tracking
- Create and track daily Islamic habits
- Set goals and track progress
- Receive reminders for your habits
- View detailed habit history

### Prayer Times
- Get accurate prayer times based on your location
- Choose from multiple calculation methods
- Receive notifications before prayer times
- View prayer times for the current day and upcoming days

### Dua & Dhikr
- Access a curated collection of duas categorized by occasion
- Use the dhikr counter with haptic feedback and sound
- Save your favorite duas and dhikrs for quick access
- View transliteration and translation of all duas and dhikrs

### Analytics Dashboard
- View detailed statistics about your habits
- Track your progress with visual charts
- See your streaks and completion rates
- Get insights and recommendations to improve consistency

## Architecture

SunnahTrack is built using Clean Architecture principles, which separates the app into three main layers:

1. **Domain Layer**: Contains the business logic, entities, and use cases
2. **Data Layer**: Handles data operations, repositories, and data sources
3. **Presentation Layer**: Manages UI components, state management, and user interactions

This architecture provides several benefits:
- **Testability**: Each layer can be tested independently
- **Maintainability**: Changes in one layer don't affect other layers
- **Scalability**: New features can be added without modifying existing code
- **Independence**: UI and data sources can be changed without affecting business logic

## Technical Details

- **State Management**: BLoC pattern for predictable state management
- **Local Storage**: Hive for efficient local data persistence
- **Dependency Injection**: GetIt for service locator pattern
- **Error Handling**: Either type from Dartz for functional error handling
- **UI**: Material Design with Islamic aesthetic elements
- **Notifications**: Flutter Local Notifications for prayer times and habit reminders

## Getting Started

### Prerequisites
- Flutter SDK (2.0 or higher)
- Dart SDK (2.12 or higher)
- Android Studio / VS Code
- Android SDK / Xcode (for iOS development)

### Installation

1. Clone the repository
   ```
   git clone https://github.com/Kandil7/sunnah_track.git
   ```

2. Navigate to the project directory
   ```
   cd sunnah_track
   ```

3. Install dependencies
   ```
   flutter pub get
   ```

4. Run the app
   ```
   flutter run
   ```

## Dependencies

- **flutter_bloc**: ^8.1.3 - State management
- **hive**: ^2.2.3 - Local storage
- **hive_flutter**: ^1.1.0 - Hive Flutter integration
- **get_it**: ^7.6.7 - Dependency injection
- **dartz**: ^0.10.1 - Functional programming
- **equatable**: ^2.0.5 - Value equality
- **http**: ^1.2.0 - Network requests
- **intl**: ^0.19.0 - Internationalization
- **shared_preferences**: ^2.2.2 - Simple data storage
- **flutter_local_notifications**: ^16.3.2 - Local notifications
- **fl_chart**: ^0.66.0 - Charts and graphs
- **google_fonts**: ^6.1.0 - Custom fonts
- **uuid**: ^4.3.3 - Unique ID generation

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

- [Aladhan API](https://aladhan.com/prayer-times-api) for prayer times data
- [Flutter](https://flutter.dev) for the amazing framework
- All the open-source packages that made this project possible
