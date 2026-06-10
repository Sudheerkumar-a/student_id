import 'package:flutter/material.dart';
import 'package:student_id/shared/presentation/theme/form_tokens.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.compact = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final buttonStyle = FilledButton.styleFrom(
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      disabledBackgroundColor: theme.colorScheme.primary.withValues(alpha: 0.35),
      disabledForegroundColor: theme.colorScheme.onPrimary.withValues(alpha: 0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FormTokens.radiusMd),
      ),
      minimumSize: compact
          ? const Size(0, 44)
          : const Size.fromHeight(FormTokens.buttonHeight),
      tapTargetSize:
          compact ? MaterialTapTargetSize.shrinkWrap : MaterialTapTargetSize.padded,
      padding: compact
          ? const EdgeInsets.symmetric(horizontal: FormTokens.spacingMd)
          : const EdgeInsets.symmetric(horizontal: FormTokens.spacingLg),
    );

    final child = isLoading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: theme.colorScheme.onPrimary,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: FormTokens.spacingXs),
              ],
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ],
          );

    final button = FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: buttonStyle,
      child: child,
    );

    if (compact) {
      return button;
    }

    return SizedBox(
      width: double.infinity,
      height: FormTokens.buttonHeight,
      child: button,
    );
  }
}
