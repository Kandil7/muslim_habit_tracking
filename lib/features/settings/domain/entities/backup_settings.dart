import 'package:equatable/equatable.dart';

/// Backup settings entity
class BackupSettings extends Equatable {
  final bool autoBackupEnabled;
  final String backupFrequency;
  final DateTime? lastBackup;
  final String backupLocation;
  final bool cloudSyncEnabled;
  final String cloudProvider;
  final bool encryptBackup;

  const BackupSettings({
    required this.autoBackupEnabled,
    required this.backupFrequency,
    this.lastBackup,
    required this.backupLocation,
    required this.cloudSyncEnabled,
    required this.cloudProvider,
    required this.encryptBackup,
  });

  @override
  List<Object?> get props => [
        autoBackupEnabled,
        backupFrequency,
        lastBackup,
        backupLocation,
        cloudSyncEnabled,
        cloudProvider,
        encryptBackup,
  ];

  BackupSettings copyWith({
    bool? autoBackupEnabled,
    String? backupFrequency,
    DateTime? lastBackup,
    String? backupLocation,
    bool? cloudSyncEnabled,
    String? cloudProvider,
    bool? encryptBackup,
  }) {
    return BackupSettings(
      autoBackupEnabled: autoBackupEnabled ?? this.autoBackupEnabled,
      backupFrequency: backupFrequency ?? this.backupFrequency,
      lastBackup: lastBackup ?? this.lastBackup,
      backupLocation: backupLocation ?? this.backupLocation,
      cloudSyncEnabled: cloudSyncEnabled ?? this.cloudSyncEnabled,
      cloudProvider: cloudProvider ?? this.cloudProvider,
      encryptBackup: encryptBackup ?? this.encryptBackup,
    );
  }
}