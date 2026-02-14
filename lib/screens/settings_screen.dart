import 'package:budget_manager/services/backup_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/budget_providers.dart';

class SettingsScreen extends ConsumerWidget {
  SettingsScreen({super.key});

  // Define some preset colors for the user to pick
  final List<Color> colorOptions = [
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.red,
    Colors.orange,
    Colors.teal,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the current values
    final currentCurrency = ref.watch(currencyProvider);

    final currentDateFormat = ref.watch(dateFormatProvider);

    final List<String> currencies = ['\$', '€', '£', '¥', 'kr', 'Rs'];
    final List<String> dateFormats = ['MM/dd/yyyy', 'dd/MM/yyyy', 'yyyy-MM-dd'];
    final themeMode = ref.watch(themeModeProvider);
    final currentColor = ref.watch(themeColorProvider);
    final startDay = ref.watch(cycleStartDayProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Localization',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
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
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text('Monthly  Cycle Start'),
            subtitle: Text('Current day:  $startDay of the month'),
            trailing: DropdownButton<int>(
              value: startDay,
              items: List.generate(28, (index) => index + 1).map((day) {
                return DropdownMenuItem(value: day, child: Text('Day $day'));
              }).toList(),
              onChanged: (newDay) {
                if (newDay != null) {
                  ref.read(cycleStartDayProvider.notifier).setDay(newDay);
                  // Refresh transactions to reflect the new period
                  ref.invalidate(transactionsProvider);
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
                  ref.read(dateFormatProvider.notifier).setFormat(newValue);
                }
              },
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Appearance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          // 1. Theme Mode Selector
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('App Theme'),
            subtitle: Text(themeMode.toString().split('.').last.toUpperCase()),
            trailing: DropdownButton<ThemeMode>(
              value: themeMode,
              underline: Container(), // Remove underline
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System Default'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light Mode'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark Mode'),
                ),
              ],
              onChanged: (newMode) {
                if (newMode != null) {
                  ref.read(themeModeProvider.notifier).setTheme(newMode);
                }
              },
            ),
          ),
          // 2. Color Picker (Horizontal List)
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('Primary Color'),
            subtitle: const Text('Tap to change app style'),
          ),
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: colorOptions.length,
              itemBuilder: (context, index) {
                final color = colorOptions[index];
                return GestureDetector(
                  onTap: () {
                    ref.read(themeColorProvider.notifier).setColor(color);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: currentColor.value == color.value
                            ? Colors.black
                            : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: currentColor.value == color.value
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
                  ),
                );
              },
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Data Management',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
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
                    '⚠️ Warning: This will overwrite all current data on this device with the backup file. This action cannot be undone.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text(
                        'Restore',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
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
