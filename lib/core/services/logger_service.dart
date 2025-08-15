import 'package:logger/logger.dart';

/// A centralized logging service for the application
class LoggerService {
  static final LoggerService _instance = LoggerService._internal();
  late Logger _logger;

  /// Factory constructor to return the singleton instance
  factory LoggerService() {
    return _instance;
  }

  /// Private constructor
  LoggerService._internal() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      level: Level.trace,
    );
  }

  /// Log a trace message
  void t(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.t(message);
  }

  /// Log a debug message
  void d(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message);
  }

  /// Log an info message
  void i(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message);
  }

  /// Log a warning message
  void w(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message);
  }

  /// Log an error message
  void e(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message);
  }

  /// Log a fatal error message
  void f(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message);
  }

  /// Set the log level
  void setLevel(Level level) {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
      level: level,
    );
  }
}
