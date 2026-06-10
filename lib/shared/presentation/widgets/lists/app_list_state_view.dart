import 'package:flutter/material.dart';
import 'package:student_id/shared/presentation/theme/form_tokens.dart';
import 'package:student_id/shared/presentation/widgets/forms/app_primary_button.dart';

class AppListLoadingView extends StatelessWidget {
  const AppListLoadingView({super.key, this.message = 'Loading...'});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: theme.colorScheme.primary),
          const SizedBox(height: FormTokens.spacingMd),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: FormTokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class AppListEmptyView extends StatelessWidget {
  const AppListEmptyView({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: FormTokens.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 56, color: FormTokens.textSecondary),
            const SizedBox(height: FormTokens.spacingMd),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: FormTokens.spacingSm),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: FormTokens.textSecondary,
                ),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: FormTokens.spacingLg),
              AppPrimaryButton(
                label: actionLabel!,
                onPressed: onAction,
                compact: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AppListErrorView extends StatelessWidget {
  const AppListErrorView({
    super.key,
    required this.message,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AppListEmptyView(
      title: 'Something went wrong',
      message: message,
      icon: Icons.error_outline_rounded,
      actionLabel: onRetry != null ? 'Try Again' : null,
      onAction: onRetry,
    );
  }
}
