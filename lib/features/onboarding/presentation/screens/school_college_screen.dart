import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:student_id/app/preferences_provider.dart';
import 'package:student_id/core/utils/pref_utils.dart';
import 'package:student_id/shared/presentation/theme/form_tokens.dart';
import 'package:student_id/shared/presentation/widgets/forms/app_form_section_card.dart';
import 'package:student_id/shared/presentation/widgets/forms/app_selection_tile.dart';

class SchoolCollegeScreen extends ConsumerWidget {
  const SchoolCollegeScreen({super.key});

  void _selectInstitute(
    BuildContext context,
    WidgetRef ref, {
    required bool isSchool,
  }) {
    ref
        .read(preferencesProvider)
        .setBoolValue(SharedPreferencesString.isSchool, isSchool);
    context.push('/hub');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: FormTokens.surfaceMuted,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome'),
            Text(
              'Choose your institute type',
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
            const AppHelperBanner(
              text:
                  'Select whether you are registering for a school or a college. You can change this later from settings.',
              icon: Icons.info_outline_rounded,
            ),
            const AppFieldGap(size: FormTokens.spacingLg),
            AppFormSectionCard(
              title: 'Institute Type',
              subtitle: 'Tap an option to continue',
              icon: Icons.account_balance_outlined,
              children: [
                AppSelectionTile(
                  icon: Icons.menu_book_outlined,
                  title: 'Schools',
                  subtitle: 'Primary & secondary school student IDs',
                  onTap: () => _selectInstitute(
                    context,
                    ref,
                    isSchool: true,
                  ),
                ),
                const AppFieldGap(),
                AppSelectionTile(
                  icon: Icons.school_outlined,
                  title: 'Colleges',
                  subtitle: 'College & university student IDs',
                  onTap: () => _selectInstitute(
                    context,
                    ref,
                    isSchool: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
