// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Future<void> showLottieOverlay(
  BuildContext context, {
  required bool success,
  required String message,
  Duration duration = const Duration(seconds: 3),
}) async {
  late OverlayEntry overlay; // pakai late biar bisa dipakai di builder

  overlay = OverlayEntry(
    builder: (_) => GestureDetector(
      onTap: () {
        if (overlay.mounted) overlay.remove();
      },
      child: Container(
        color: Colors.black.withOpacity(0.7),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              success
                  ? 'assets/animations/success.json'
                  : 'assets/animations/failed.json',
              width: 200,
              height: 200,
              repeat: false,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Overlay.of(context).insert(overlay);

  await Future.delayed(duration);
  if (overlay.mounted) overlay.remove();
}
