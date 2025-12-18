// ignore_for_file: use_build_context_synchronously

import 'package:absensi_ppkdjp_b3/extension/navigation.dart';
import 'package:absensi_ppkdjp_b3/l10n/app_localizations.dart';
import 'package:absensi_ppkdjp_b3/preference/shared_preference.dart';
import 'package:absensi_ppkdjp_b3/utils/locale_provider.dart';
import 'package:absensi_ppkdjp_b3/views/auth/login_presensi.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatelessWidget {
  static const String id = '/onboard_presensi';
  const OnboardingScreen({super.key});

  Future<void> _onIntroEnd(BuildContext context) async {
    await PreferenceHandler.saveOnboardingShown(true);
    context.pushReplacement(LoginPresensi());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final localeProvider = Provider.of<LocaleProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    final bodyStyle = TextStyle(
      fontSize: 16,
      color: colorScheme.onSurfaceVariant,
    );

    final pageDecoration = PageDecoration(
      bodyTextStyle: bodyStyle,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<Locale>(
            icon: Icon(Icons.g_translate, color: colorScheme.primary),
            onSelected: (locale) => localeProvider.setLocale(locale),
            itemBuilder: (context) => [
              PopupMenuItem(value: null, child: Text(l10n.themeSystem)),
              PopupMenuItem(
                value: const Locale('id'),
                child: Text(l10n.languageId),
              ),
              PopupMenuItem(
                value: const Locale('en'),
                child: Text(l10n.languageEn),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            title: l10n.onboardingTitle1,
            body: l10n.onboardingDesc1,
            image: Icon(
              Icons.access_time,
              size: 150,
              color: colorScheme.primary,
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: l10n.onboardingTitle2,
            body: l10n.onboardingDesc2,
            image: Icon(Icons.touch_app, size: 150, color: colorScheme.primary),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: l10n.onboardingTitle3,
            body: l10n.onboardingDesc3,
            image: Icon(
              Icons.verified_user,
              size: 150,
              color: colorScheme.primary,
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: l10n.getStarted,
            body: l10n.onboardingDesc4,
            image: Icon(
              Icons.rocket_launch,
              size: 150,
              color: colorScheme.primary,
            ),
            decoration: pageDecoration,
          ),
        ],
        onDone: () => _onIntroEnd(context),
        showSkipButton: true,
        skip: Text(l10n.skip),
        next: const Icon(Icons.arrow_forward),
        done: Text(
          l10n.getStarted,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        dotsDecorator: DotsDecorator(
          size: const Size.square(8.0),
          activeSize: const Size(20.0, 8.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          activeColor: colorScheme.primary,
          color: colorScheme.outlineVariant,
        ),
      ),
    );
  }
}
