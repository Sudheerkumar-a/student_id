import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:student_id/app/preferences_provider.dart';
import 'package:student_id/core/utils/pref_utils.dart';
import 'package:student_id/features/onboarding/presentation/providers/onboarding_navigation.dart';
import 'package:student_id/shared/presentation/theme/form_tokens.dart';
import 'package:student_id/shared/presentation/widgets/forms/app_form_section_card.dart';
import 'package:student_id/shared/presentation/widgets/forms/app_selection_tile.dart';

class StudentTeacherScreen extends ConsumerWidget {
  const StudentTeacherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final prefs = ref.read(preferencesProvider);
    final isSchool =
        prefs.getBoolValue(SharedPreferencesString.isSchool);
    final instituteLabel = isSchool ? 'School' : 'College';

    return Scaffold(
      backgroundColor: FormTokens.surfaceMuted,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$instituteLabel Portal'),
            Text(
              'What would you like to do?',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.85),
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: FormTokens.screenPadding.copyWith(
          bottom: FormTokens.spacingXl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppHelperBanner(
              text: isSchool
                  ? 'Register student IDs, manage records as staff, or check in visitors for your school.'
                  : 'Register student IDs, manage records as staff, or check in visitors for your college.',
              icon: Icons.info_outline_rounded,
            ),
            const AppFieldGap(size: FormTokens.spacingLg),
            AppFormSectionCard(
              title: 'Select an Option',
              subtitle: 'Tap to continue',
              icon: Icons.dashboard_outlined,
              children: [
                AppSelectionTile(
                  icon: Icons.person_outline,
                  title: 'Students',
                  subtitle: 'Register or update student ID cards',
                  onTap: () {
                    final target =
                        OnboardingNavigation.catalogEntryForHub(prefs);
                    context.push(target.route, extra: target.extra);
                  },
                ),
                const AppFieldGap(),
                AppSelectionTile(
                  icon: Icons.admin_panel_settings_outlined,
                  title: 'Teachers',
                  subtitle: 'Staff login to review and approve IDs',
                  onTap: () => context.push('/login'),
                ),
                const AppFieldGap(),
                AppSelectionTile(
                  icon: Icons.groups_outlined,
                  title: 'Visitors',
                  subtitle: 'Register parents or guests visiting campus',
                  onTap: () => context.push('/visitors'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
