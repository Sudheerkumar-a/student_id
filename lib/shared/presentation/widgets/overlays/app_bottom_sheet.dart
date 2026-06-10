import 'package:flutter/material.dart';
import 'package:student_id/shared/presentation/theme/form_tokens.dart';

class AppBottomSheet {
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    String? title,
    String? subtitle,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppBottomSheetContainer(
        title: title,
        subtitle: subtitle,
        child: child,
      ),
    );
  }
}

class AppBottomSheetContainer extends StatelessWidget {
  const AppBottomSheetContainer({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
  });

  final Widget child;
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(FormTokens.radiusLg),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: FormTokens.spacingSm),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: FormTokens.borderColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              if (title != null) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    FormTokens.spacingMd,
                    FormTokens.spacingMd,
                    FormTokens.spacingMd,
                    FormTokens.spacingXs,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(FormTokens.spacingSm),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer
                              .withValues(alpha: 0.35),
                          borderRadius:
                              BorderRadius.circular(FormTokens.radiusMd),
                        ),
                        child: Icon(
                          Icons.photo_camera_outlined,
                          color: theme.colorScheme.primary,
                          size: FormTokens.iconSize,
                        ),
                      ),
                      const SizedBox(width: FormTokens.spacingSm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title!,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (subtitle != null)
                              Text(
                                subtitle!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: FormTokens.textSecondary,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  FormTokens.spacingMd,
                  0,
                  FormTokens.spacingMd,
                  FormTokens.spacingMd,
                ),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppBottomSheetOption extends StatelessWidget {
  const AppBottomSheetOption({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: FormTokens.spacingSm),
      child: Material(
        color: FormTokens.surfaceMuted,
        borderRadius: BorderRadius.circular(FormTokens.radiusMd),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(FormTokens.radiusMd),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(FormTokens.spacingMd),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(FormTokens.radiusMd),
              border: Border.all(color: FormTokens.borderColor),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(FormTokens.radiusMd),
                  ),
                  child: Icon(icon, color: theme.colorScheme.primary),
                ),
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
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: FormTokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: FormTokens.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
