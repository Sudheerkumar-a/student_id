import 'package:flutter/material.dart';
import 'package:student_id/shared/presentation/theme/form_tokens.dart';
import 'package:student_id/shared/presentation/widgets/overlays/app_dialog.dart';

class AppUploadSuccessShell extends StatelessWidget {
  const AppUploadSuccessShell({
    super.key,
    required this.cardTitle,
    required this.cardBody,
    this.subtitle = 'ID card has been created successfully',
  });

  final String cardTitle;
  final String subtitle;
  final Widget cardBody;

  static Future<void> show(
    BuildContext context, {
    required String cardTitle,
    required Widget cardBody,
    String subtitle = 'ID card has been created successfully',
  }) {
    return AppDialog.show(
      context,
      child: AppUploadSuccessShell(
        cardTitle: cardTitle,
        subtitle: subtitle,
        cardBody: cardBody,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppDialogHeader(
          title: 'Upload Successful',
          subtitle: subtitle,
          icon: Icons.check_circle_outline_rounded,
          iconColor: Colors.green.shade600,
        ),
        const SizedBox(height: FormTokens.spacingMd),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(FormTokens.spacingMd),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(FormTokens.radiusMd),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: FormTokens.spacingMd,
                  vertical: FormTokens.spacingXs,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.5),
                  borderRadius: BorderRadius.circular(FormTokens.radiusMd),
                ),
                child: Text(
                  cardTitle,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              const SizedBox(height: FormTokens.spacingMd),
              cardBody,
            ],
          ),
        ),
        const SizedBox(height: FormTokens.spacingLg),
        AppDialogActions(
          primaryLabel: 'Done',
          onPrimary: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

class AppIdCardInfoRow extends StatelessWidget {
  const AppIdCardInfoRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
