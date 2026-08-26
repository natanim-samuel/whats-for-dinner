import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final notifications = ref.watch(notificationsProvider);
    final language = ref.watch(languageProvider);

    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Preferences',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 10),

          Card(
            child: Column(
              children: [
                // DARK MODE
                SwitchListTile(
                  secondary: Icon(
                    isDark
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                  ),

                  title: const Text(
                    'Dark Mode',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  subtitle: Text(
                    isDark ? 'Dark appearance is enabled' : 'Light appearance is enabled',
                  ),

                  value: isDark,

                  onChanged: (value) {
                    ref.read(themeModeProvider.notifier).state =
                    value ? ThemeMode.dark : ThemeMode.light;
                  },
                ),

                const Divider(height: 1),

                // NOTIFICATIONS
                SwitchListTile(
                  secondary: const Icon(
                    Icons.notifications_outlined,
                  ),

                  title: const Text(
                    'Notifications',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  subtitle: Text(
                    notifications
                        ? 'Recipe and reminder notifications are enabled'
                        : 'Notifications are disabled',
                  ),

                  value: notifications,

                  onChanged: (value) {
                    ref.read(notificationsProvider.notifier).state =
                        value;
                  },
                ),

                const Divider(height: 1),

                // LANGUAGE
                ListTile(
                  leading: const Icon(
                    Icons.language_outlined,
                  ),

                  title: const Text(
                    'Language',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  subtitle: Text(language),

                  trailing: const Icon(
                    Icons.chevron_right,
                  ),

                  onTap: () {
                    _showLanguageDialog(context, ref);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(
      BuildContext context,
      WidgetRef ref,
      ) {
    final currentLanguage = ref.read(languageProvider);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Language'),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('English'),
                value: 'English',
                groupValue: currentLanguage,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(languageProvider.notifier).state = value;
                    Navigator.pop(context);
                  }
                },
              ),

              RadioListTile<String>(
                title: const Text('Amharic'),
                value: 'Amharic',
                groupValue: currentLanguage,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(languageProvider.notifier).state = value;
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}