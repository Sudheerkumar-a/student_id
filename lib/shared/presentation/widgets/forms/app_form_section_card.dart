import 'package:flutter/material.dart';
import 'package:student_id/shared/presentation/theme/form_tokens.dart';

class AppFormSectionCard extends StatelessWidget {
  const AppFormSectionCard({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.icon,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FormTokens.radiusLg),
        side: const BorderSide(color: FormTokens.borderColor),
      ),
      child: Padding(
        padding: FormTokens.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(FormTokens.spacingSm),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(FormTokens.radiusMd),
                    ),
                    child: Icon(
                      icon,
                      size: FormTokens.iconSize,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: FormTokens.spacingSm),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: FormTokens.textPrimary,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: FormTokens.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: FormTokens.spacingMd),
            ...children,
          ],
        ),
      ),
    );
  }
}

class AppFieldGap extends StatelessWidget {
  const AppFieldGap({super.key, this.size = FormTokens.spacingMd});

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(height: size);
}

class AppHelperBanner extends StatelessWidget {
  const AppHelperBanner({super.key, required this.text, this.icon});

  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(FormTokens.spacingSm),
      decoration: BoxDecoration(
        color: FormTokens.brandPurpleLight,
        borderRadius: BorderRadius.circular(FormTokens.radiusMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon ?? Icons.info_outline_rounded,
            size: 18,
            color: FormTokens.brandPurple,
          ),
          const SizedBox(width: FormTokens.spacingXs),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: FormTokens.brandPurple,
                    height: 1.4,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
