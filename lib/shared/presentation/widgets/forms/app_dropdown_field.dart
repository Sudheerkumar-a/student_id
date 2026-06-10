import 'package:flutter/material.dart';
import 'package:student_id/shared/presentation/theme/form_tokens.dart';

class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.itemLabel,
    this.value,
    this.hint,
    this.helperText,
    this.icon,
    this.enabled = true,
    this.isLoading = false,
    this.errorMessage,
    this.onChanged,
    this.validator,
  });

  final String label;
  final List<T> items;
  final String Function(T item) itemLabel;
  final T? value;
  final String? hint;
  final String? helperText;
  final IconData? icon;
  final bool enabled;
  final bool isLoading;
  final String? errorMessage;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = !enabled || isLoading;

    if (errorMessage != null && items.isEmpty) {
      return _EmptyDropdownState(
        label: label,
        message: errorMessage!,
        icon: icon,
      );
    }

    return DropdownButtonFormField<T>(
      value: items.contains(value) ? value : null,
      isExpanded: true,
      hint: Text(
        isLoading ? 'Loading...' : (hint ?? 'Select $label'),
        style: theme.textTheme.bodyMedium?.copyWith(
          color: FormTokens.textSecondary,
        ),
      ),
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        prefixIcon: icon != null
            ? Icon(icon, size: FormTokens.iconSize, color: theme.colorScheme.primary)
            : null,
        suffixIcon: isLoading
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : const Icon(Icons.keyboard_arrow_down_rounded),
        filled: true,
        fillColor: isDisabled ? FormTokens.surfaceMuted : theme.colorScheme.surface,
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(
                itemLabel(item),
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyLarge,
              ),
            ),
          )
          .toList(),
      onChanged: isDisabled ? null : onChanged,
      validator: validator,
    );
  }
}

class _EmptyDropdownState extends StatelessWidget {
  const _EmptyDropdownState({
    required this.label,
    required this.message,
    this.icon,
  });

  final String label;
  final String message;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null
            ? Icon(icon, size: FormTokens.iconSize)
            : null,
        filled: true,
        fillColor: FormTokens.surfaceMuted,
        errorText: message,
      ),
      child: Text(
        'Unable to load options',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: FormTokens.textSecondary,
            ),
      ),
    );
  }
}
