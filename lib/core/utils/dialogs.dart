import 'package:flutter/material.dart';
import 'package:student_id/core/errors/error_pop.dart';
import 'package:student_id/shared/presentation/theme/form_tokens.dart';
import 'package:student_id/shared/presentation/widgets/overlays/app_dialog.dart';

class Dialogs {
  static Future<T?> loader<T>(BuildContext context, {String? message}) {
    return showDialog<T>(
      barrierDismissible: false,
      context: context,
      builder: (context) => PopScope(
        canPop: false,
        child: AppLoadingDialog(message: message ?? 'Please wait...'),
      ),
    );
  }

  static Future<T?> showGenericErrorPopup<T>(
    BuildContext context,
    ErrorPopup data,
  ) {
    return AppDialog.show(
      context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppDialogHeader(
            title: data.title,
            subtitle: 'Something went wrong',
            icon: Icons.error_outline_rounded,
            iconColor: FormTokens.errorColor,
          ),
          const SizedBox(height: FormTokens.spacingMd),
          Text(
            data.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: FormTokens.spacingLg),
          AppDialogActions(
            primaryLabel: 'Okay',
            onPrimary: () => Navigator.pop(context),
            secondaryLabel: 'Cancel',
            onSecondary: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  static Future<void> showInfoDialog(
    BuildContext context,
    String title,
    String message,
  ) {
    return AppDialog.show(
      context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppDialogHeader(
            title: title,
            subtitle: 'Information',
            icon: Icons.info_outline_rounded,
          ),
          const SizedBox(height: FormTokens.spacingMd),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: FormTokens.spacingLg),
          AppDialogActions(
            primaryLabel: 'Okay',
            onPrimary: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
