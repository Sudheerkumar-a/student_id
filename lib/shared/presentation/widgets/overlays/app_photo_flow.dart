import 'package:flutter/material.dart';
import 'package:student_id/features/camera/presentation/widgets/pic_image_widget.dart';
import 'package:student_id/features/students/presentation/widgets/photo_instructions.dart';

/// Standard photo pick flow: guidelines dialog → source bottom sheet.
class AppPhotoFlow {
  static Future<void> pickPhoto(
    BuildContext context,
    void Function(String path) onSelected, {
    bool showInstructions = true,
  }) async {
    if (showInstructions) {
      await PhotoInstructions.show(context);
      if (!context.mounted) return;
    }
    await PicImagePopup.show(context, onSelected);
  }
}
