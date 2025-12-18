import 'package:absensi_ppkdjp_b3/l10n/app_localizations.dart';
import 'package:absensi_ppkdjp_b3/utils/app_logo.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.aboutApp,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        backgroundColor: theme.colorScheme.primaryContainer,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primaryContainer.withOpacity(0.15),
              theme.colorScheme.surface,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),

              // Logo + App info
              FadeInUp(
                duration: const Duration(milliseconds: 700),
                child: Card(
                  color: theme.colorScheme.surfaceContainerHighest,
                  surfaceTintColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 28,
                      horizontal: 20,
                    ),
                    child: Column(
                      children: [
                        AppLogo(height: 160, width: 160),
                        const SizedBox(height: 20),
                        Text(
                          AppLocalizations.of(context)!.appName,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.appVersion("1.0.0"),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Deskripsi
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 700),
                child: Text(
                  AppLocalizations.of(context)!.appDescription,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),

              const Spacer(),

              // Tombol / aksi tambahan (opsional)
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                duration: const Duration(milliseconds: 700),
                child: FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    // Aksi contoh: info dev
                    showAboutDialog(
                      context: context,
                      applicationName: AppLocalizations.of(context)!.appName,
                      applicationVersion: "1.0.0",
                      applicationLegalese: "© 2025 - Gerry Bagaskoro Putro",
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.developerInfo),
                ),
              ),

              const SizedBox(height: 24),

              // Footer
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                duration: const Duration(milliseconds: 700),
                child: Text(
                  "© 2025 - Gerry Bagaskoro Putro",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
