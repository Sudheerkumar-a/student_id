import 'package:flutter/material.dart';
import 'package:student_id/shared/presentation/theme/form_tokens.dart';
import 'package:student_id/shared/presentation/widgets/overlays/app_dialog.dart';

class PhotoInstructions extends StatelessWidget {
  const PhotoInstructions({super.key});

  static const _instructions = [
    'Photo background should be white or plain.',
    'Avoid noisy or cluttered backgrounds.',
    'Face should be clearly visible and pointing at the camera.',
    'Ensure good lighting with no shadows on the face.',
  ];

  static Future<void> show(BuildContext context) {
    return AppDialog.show(
      context,
      child: const PhotoInstructions(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppDialogHeader(
          title: 'Photo Guidelines',
          subtitle: 'Please follow these instructions for a valid ID photo',
          icon: Icons.face_retouching_natural_outlined,
        ),
        const SizedBox(height: FormTokens.spacingMd),
        ..._instructions.map((text) => AppDialogBullet(text: text)),
        const SizedBox(height: FormTokens.spacingMd),
        AppDialogActions(
          primaryLabel: 'Got it',
          onPrimary: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
