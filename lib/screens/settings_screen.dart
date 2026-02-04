import 'package:budget_manager/services/backup_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/budget_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the current values
    final currentCurrency = ref.watch(currencyProvider);

    final currentDateFormat = ref.watch(dateFormatProvider);

    final List<String> currencies = ['\$', '€', '£', '¥', 'kr', 'Rs'];
    final List<String> dateFormats = ['MM/dd/yyyy', 'dd/MM/yyyy', 'yyyy-MM-dd'];

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('Localization',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
          const SizedBox(height: 10),

          // Currency Selector
          ListTile(
            title: const Text('Currency Symbol'),
            subtitle: Text('Current: $currentCurrency'),
            trailing: DropdownButton<String>(
              value: currentCurrency,
              items: currencies.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  ref.read(currencyProvider.notifier).setCurrency(newValue);
                }
              },
            ),
          ),
          const Divider(),

          // Date Format Selector
          ListTile(
            title: const Text('Date Format'),
            subtitle: Text('Current: $currentDateFormat'),
            trailing: DropdownButton<String>(
              value: currentDateFormat,
              items: dateFormats.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  ref.read(dateFormatProvider.notifier).setFormat(newValue);                }
              },
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Data Management',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
          ),

// BACKUP BUTTON
          ListTile(
            leading: const Icon(Icons.cloud_upload),
            title: const Text('Backup Data'),
            subtitle: const Text('Save your data to a file'),
            onTap: () async {
              await BackupService().createBackup(context);
            },
          ),

          ListTile(
            leading: const Icon(Icons.cloud_download),
            title: const Text('Restore Data'),
            subtitle: const Text('Import data from a backup file'),
            onTap: () async {
              // Show confirmation dialog before restoring
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Restore Backup?'),
                  content: const Text(
                      '⚠️ Warning: This will overwrite all current data on this device with the backup file. This action cannot be undone.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                    TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Restore', style: TextStyle(color: Colors.red))),
                  ],
                ),
              );

              if (confirm == true) {
                final success = await BackupService().restoreBackup(context);
                if (success) {
                  // REFRESH RIVERPOD STATE
                  // This forces the providers to re-fetch the new data from the DB
                  ref.invalidate(transactionsProvider);
                  ref.invalidate(categoriesProvider);
                  // Optionally navigate back to Dashboard
                  Navigator.pop(context);
                }
              }
            },
          ),
        ],
      ),
    );
  }
}