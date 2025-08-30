import 'package:flutter/material.dart';
import 'package:muslim_habbit/features/settings/domain/entities/backup_settings.dart';

class BackupSyncPage extends StatefulWidget {
  const BackupSyncPage({super.key});

  @override
  State<BackupSyncPage> createState() => _BackupSyncPageState();
}

class _BackupSyncPageState extends State<BackupSyncPage> {
  // Mock backup settings - in a real app, this would come from a bloc/provider
  late BackupSettings _backupSettings;
  bool _isBackingUp = false;
  bool _isRestoring = false;

  @override
  void initState() {
    super.initState();
    _backupSettings = const BackupSettings(
      autoBackupEnabled: true,
      backupFrequency: 'daily',
      lastBackup: null,
      backupLocation: 'internal',
      cloudSyncEnabled: false,
      cloudProvider: 'none',
      encryptBackup: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backup & Sync'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBackupSection(),
            const SizedBox(height: 32),
            _buildSyncSection(),
            const SizedBox(height: 32),
            _buildEncryptionSection(),
            const SizedBox(height: 32),
            _buildManualActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackupSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Automatic Backup',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile.adaptive(
              title: const Text('Enable Automatic Backup'),
              value: _backupSettings.autoBackupEnabled,
              onChanged: (value) {
                setState(() {
                  _backupSettings = _backupSettings.copyWith(
                    autoBackupEnabled: value,
                  );
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Backup Frequency'),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'daily', label: Text('Daily')),
                ButtonSegment(value: 'weekly', label: Text('Weekly')),
                ButtonSegment(value: 'monthly', label: Text('Monthly')),
              ],
              selected: {_backupSettings.backupFrequency},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _backupSettings = _backupSettings.copyWith(
                    backupFrequency: newSelection.first,
                  );
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Backup Location'),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'internal', label: Text('Internal')),
                ButtonSegment(value: 'external', label: Text('External')),
              ],
              selected: {_backupSettings.backupLocation},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _backupSettings = _backupSettings.copyWith(
                    backupLocation: newSelection.first,
                  );
                });
              },
            ),
            if (_backupSettings.lastBackup != null) ...[
              const SizedBox(height: 16),
              Text(
                'Last backup: ${_formatDateTime(_backupSettings.lastBackup!)}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSyncSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cloud Sync',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile.adaptive(
              title: const Text('Enable Cloud Sync'),
              value: _backupSettings.cloudSyncEnabled,
              onChanged: (value) {
                setState(() {
                  _backupSettings = _backupSettings.copyWith(
                    cloudSyncEnabled: value,
                  );
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Cloud Provider'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _backupSettings.cloudProvider,
              items: const [
                DropdownMenuItem(value: 'none', child: Text('None')),
                DropdownMenuItem(value: 'google_drive', child: Text('Google Drive')),
                DropdownMenuItem(value: 'dropbox', child: Text('Dropbox')),
                DropdownMenuItem(value: 'icloud', child: Text('iCloud')),
              ],
              onChanged: _backupSettings.cloudSyncEnabled
                  ? (value) {
                      setState(() {
                        _backupSettings = _backupSettings.copyWith(
                          cloudProvider: value!,
                        );
                      });
                    }
                  : null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Cloud sync keeps your data safe and accessible across devices',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEncryptionSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Backup Encryption',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile.adaptive(
              title: const Text('Encrypt Backups'),
              subtitle: const Text('Protect your data with encryption'),
              value: _backupSettings.encryptBackup,
              onChanged: (value) {
                setState(() {
                  _backupSettings = _backupSettings.copyWith(
                    encryptBackup: value,
                  );
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Encryption adds an extra layer of security to your backups',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManualActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manual Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isBackingUp ? null : _performBackup,
                icon: _isBackingUp
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.backup),
                label: Text(_isBackingUp ? 'Backing Up...' : 'Backup Now'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isRestoring ? null : _restoreBackup,
                icon: _isRestoring
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.restore),
                label: Text(_isRestoring ? 'Restoring...' : 'Restore Backup'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _performBackup() async {
    setState(() {
      _isBackingUp = true;
    });

    // Simulate backup process
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isBackingUp = false;
      _backupSettings = _backupSettings.copyWith(
        lastBackup: DateTime.now(),
      );
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Backup completed successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _restoreBackup() async {
    setState(() {
      _isRestoring = true;
    });

    // Simulate restore process
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRestoring = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Backup restored successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}