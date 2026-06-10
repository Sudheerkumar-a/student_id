import 'package:flutter/material.dart';
import 'package:student_id/shared/presentation/theme/form_tokens.dart';

class AppListItemCard extends StatelessWidget {
  const AppListItemCard({
    super.key,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.icon,
    this.leading,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: FormTokens.spacingSm),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(FormTokens.radiusMd),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(FormTokens.radiusMd),
          child: Container(
            padding: const EdgeInsets.all(FormTokens.spacingMd),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(FormTokens.radiusMd),
              border: Border.all(color: FormTokens.borderColor),
            ),
            child: Row(
              children: [
                if (leading != null)
                  leading!
                else if (icon != null)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer
                          .withValues(alpha: 0.35),
                      borderRadius:
                          BorderRadius.circular(FormTokens.radiusMd),
                    ),
                    child: Icon(
                      icon,
                      color: theme.colorScheme.primary,
                      size: FormTokens.iconSize,
                    ),
                  ),
                if (leading != null || icon != null)
                  const SizedBox(width: FormTokens.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
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
                trailing ??
                    Icon(
                      Icons.chevron_right_rounded,
                      color: theme.colorScheme.primary,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
