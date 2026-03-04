import 'package:budget_manager/l10n/app_localizations.dart';
import 'package:budget_manager/services/backup_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/budget_providers.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/language_provider.dart';

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
    final l10n = AppLocalizations.of(context)!;
    // Watch the current values
    final currentCurrency = ref.watch(currencyProvider);

    final currentDateFormat = ref.watch(dateFormatProvider);

    final List<String> currencies = ['\$', '€', '£', '¥', 'kr', 'Rs'];
    final List<String> dateFormats = ['MM/dd/yyyy', 'dd/MM/yyyy', 'yyyy-MM-dd'];
    final themeMode = ref.watch(themeModeProvider);
    final currentColor = ref.watch(themeColorProvider);
    final startDay = ref.watch(cycleStartDayProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            l10n.localization,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 10),

          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.selectLanguage),
            trailing: DropdownButton<String>(
              value: ref.watch(localeProvider).languageCode,
              items: [
                DropdownMenuItem(value: 'en', child: Text(l10n.english)),
                DropdownMenuItem(value: 'fr', child: Text(l10n.french)),
                DropdownMenuItem(value: 'es', child: Text(l10n.spanish)),
                DropdownMenuItem(value: 'ar', child: Text(l10n.arabic)),
              ],
              onChanged: (code) {
                if (code != null) {
                  ref.read(localeProvider.notifier).setLocale(Locale(code));
                }
              },
            ),
          ),
          const SizedBox(height: 10,),// Currency Selector
          ListTile(
            title: Text(l10n.currencySymbol),
            subtitle: Text(l10n.currentValue(currentCurrency)),
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
          const SizedBox(height: 10,),// Currency Selector
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: Text(l10n.monthlyCycleStart),
            subtitle: Text(l10n.currentCycleDay(startDay)),
            trailing: DropdownButton<int>(
              value: startDay,
              items: List.generate(28, (index) => index + 1).map((day) {
                return DropdownMenuItem(value: day, child: Text(l10n.day(day)));
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
          const SizedBox(height: 10,),// Currency Selector

          // Date Format Selector
          ListTile(
            title: Text(l10n.dateFormat),
            subtitle: Text(l10n.currentValue(currentDateFormat)),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              l10n.appearance,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          // 1. Theme Mode Selector
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: Text(l10n.appTheme),
            subtitle: Text(themeMode.toString().split('.').last.toUpperCase()),
            trailing: DropdownButton<ThemeMode>(
              value: themeMode,
              underline: Container(), // Remove underline
              items: [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text(l10n.systemDefault),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(l10n.lightMode),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text(l10n.darkMode),
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
            title: Text(l10n.primaryColor),
            subtitle: Text(l10n.tapToChangeStyle),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              l10n.dataManagement,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),

          // BACKUP BUTTON
          ListTile(
            leading: const Icon(Icons.cloud_upload),
            title: Text(l10n.backupData),
            subtitle: Text(l10n.backupSubtitle),
            onTap: () async {
              await BackupService().createBackup(context);
            },
          ),

          ListTile(
            leading: const Icon(Icons.cloud_download),
            title: Text(l10n.restoreData),
            subtitle: Text(l10n.restoreSubtitle),
            onTap: () async {
              // Show confirmation dialog before restoring
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(l10n.restoreBackupTitle),
                  content: Text(l10n.restoreWarning),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(l10n.cancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(
                        l10n.restore,
                        style: const TextStyle(color: Colors.red),
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
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              l10n.developerInfo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Ahmad Bahaa',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // BACKUP BUTTON
          ListTile(
            leading: const Icon(Icons.call),
            title: Text(l10n.phoneNumber),
            subtitle: const Text('+201126052979'),
            onTap: () async {
              _makePhoneCall();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall() async {
    final Uri launchUri = Uri(scheme: 'tel', path: '+201126052979');
    await launchUrl(launchUri);
  }


}
