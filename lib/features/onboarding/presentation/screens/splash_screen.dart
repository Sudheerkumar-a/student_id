import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:student_id/app/preferences_provider.dart';
import 'package:student_id/features/onboarding/presentation/providers/onboarding_navigation.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 3), (Timer t) async {
      t.cancel();
      if (!mounted) return;
      final prefs = ref.read(preferencesProvider);
      final target = OnboardingNavigation.resolveAfterSplash(prefs);
      context.go(target.route, extra: target.extra);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              width: 200,
              height: 200,
              image: AssetImage('assets/images/ic_splash.png'),
            )
          ],
        ),
      ),
    );
  }
}
