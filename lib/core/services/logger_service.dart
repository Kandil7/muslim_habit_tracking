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
        printTime: true,
      ),
      level: Level.verbose,
    );
  }

  /// Log a verbose message
  void v(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.v(message);
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
  void wtf(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.wtf(message);
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
