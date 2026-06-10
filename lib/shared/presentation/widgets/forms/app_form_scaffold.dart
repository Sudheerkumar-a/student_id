import 'package:flutter/material.dart';
import 'package:student_id/shared/presentation/theme/form_tokens.dart';
import 'package:student_id/shared/presentation/widgets/forms/app_primary_button.dart';

class AppFormScaffold extends StatelessWidget {
  const AppFormScaffold({
    super.key,
    required this.title,
    required this.body,
    this.subtitle,
    this.bottomLabel,
    this.onBottomPressed,
    this.bottomEnabled = true,
    this.bottomLoading = false,
    this.showBottomBar = true,
  });

  final String title;
  final String? subtitle;
  final Widget body;
  final String? bottomLabel;
  final VoidCallback? onBottomPressed;
  final bool bottomEnabled;
  final bool bottomLoading;
  final bool showBottomBar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: FormTokens.surfaceMuted,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            if (subtitle != null)
              Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.85),
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: FormTokens.screenPadding.copyWith(
                bottom: showBottomBar ? FormTokens.spacingMd : FormTokens.spacingXl,
              ),
              child: body,
            ),
          ),
          if (showBottomBar && bottomLabel != null)
            _StickyBottomBar(
              label: bottomLabel!,
              onPressed: onBottomPressed,
              enabled: bottomEnabled,
              isLoading: bottomLoading,
            ),
        ],
      ),
    );
  }
}

class _StickyBottomBar extends StatelessWidget {
  const _StickyBottomBar({
    required this.label,
    required this.onPressed,
    required this.enabled,
    required this.isLoading,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        FormTokens.spacingMd,
        FormTokens.spacingSm,
        FormTokens.spacingMd,
        FormTokens.spacingMd,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: AppPrimaryButton(
          label: label,
          onPressed: enabled ? onPressed : null,
          isLoading: isLoading,
        ),
      ),
    );
  }
}
