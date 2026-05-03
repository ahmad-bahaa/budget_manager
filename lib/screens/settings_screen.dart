import 'package:budget_manager/l10n/app_localizations.dart';
import 'package:budget_manager/screens/cloud_sync_screen.dart';
import 'package:budget_manager/services/backup_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/budget_providers.dart';
import '../providers/api_key_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/language_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final List<Color> colorOptions = [
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.red,
    Colors.orange,
    Colors.teal,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentCurrency = ref.watch(currencyProvider);
    final currentDateFormat = ref.watch(dateFormatProvider);

    final List<String> currencies = ['\$', '€', '£', '¥', 'kr', 'Rs'];
    final List<String> dateFormats = ['MM/dd/yyyy', 'dd/MM/yyyy', 'yyyy-MM-dd'];
    final themeMode = ref.watch(themeModeProvider);
    final currentColor = ref.watch(themeColorProvider);
    final startDay = ref.watch(cycleStartDayProvider);
    final apiKey = ref.watch(apiKeyProvider);

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
          const SizedBox(height: 10),
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
          const SizedBox(height: 10),
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
                  ref.invalidate(transactionsProvider);
                }
              },
            ),
          ),
          const SizedBox(height: 10),

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
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: Text(l10n.appTheme),
            subtitle: Text(themeMode.toString().split('.').last.toUpperCase()),
            trailing: DropdownButton<ThemeMode>(
              value: themeMode,
              underline: Container(),
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

          // --- AI Settings Section ---
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'AI Integration',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.vpn_key),
            title: const Text('Gemini API Key'),
            subtitle: Text(apiKey.isEmpty ? 'Not Set' : '••••••••••••••••'),
            trailing: const Icon(Icons.edit),
            onTap: () => _showApiKeyDialog(context),
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

          ListTile(
            leading: const Icon(Icons.sync),
            title: Text(l10n.cloudSync),
            subtitle: Text(l10n.cloudSyncSubtitle),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CloudSyncScreen(),
                ),
              );
            },
          ),
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
                  ref.invalidate(transactionsProvider);
                  ref.invalidate(categoriesProvider);
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

  void _showApiKeyDialog(BuildContext context) {
    final controller = TextEditingController(text: ref.read(apiKeyProvider));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Gemini API Key'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter your API key here',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => launchUrl(
                Uri.parse('https://aistudio.google.com/app/apikey'),
              ),
              child: const Text(
                'How to get an API key?',
                style: TextStyle(
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(apiKeyProvider.notifier).setKey(controller.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('API Key saved successfully!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Save'),
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
