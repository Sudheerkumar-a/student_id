import 'package:flutter/material.dart';
import 'package:student_id/shared/presentation/theme/form_tokens.dart';

class AppRadioOption<T> {
  final T value;
  final String label;
  final IconData? icon;

  const AppRadioOption({
    required this.value,
    required this.label,
    this.icon,
  });
}

class AppRadioOptionGroup<T> extends StatelessWidget {
  const AppRadioOptionGroup({
    super.key,
    required this.title,
    required this.options,
    required this.groupValue,
    required this.onChanged,
  });

  final String title;
  final List<AppRadioOption<T>> options;
  final T? groupValue;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: FormTokens.textPrimary,
          ),
        ),
        const SizedBox(height: FormTokens.spacingSm),
        ...options.map((option) {
          final selected = groupValue == option.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: FormTokens.spacingXs),
            child: InkWell(
              onTap: () => onChanged(option.value),
              borderRadius: BorderRadius.circular(FormTokens.radiusMd),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: FormTokens.spacingMd,
                  vertical: FormTokens.spacingSm,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(FormTokens.radiusMd),
                  border: Border.all(
                    color: selected
                        ? theme.colorScheme.primary
                        : FormTokens.borderColor,
                    width: selected ? 1.5 : 1,
                  ),
                  color: selected
                      ? theme.colorScheme.primaryContainer.withValues(alpha: 0.25)
                      : theme.colorScheme.surface,
                ),
                child: Row(
                  children: [
                    if (option.icon != null) ...[
                      Icon(
                        option.icon,
                        size: FormTokens.iconSize,
                        color: selected
                            ? theme.colorScheme.primary
                            : FormTokens.textSecondary,
                      ),
                      const SizedBox(width: FormTokens.spacingSm),
                    ],
                    Expanded(
                      child: Text(
                        option.label,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                    Radio<T>(
                      value: option.value,
                      groupValue: groupValue,
                      onChanged: onChanged,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
