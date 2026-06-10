import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_id/shared/presentation/widgets/overlays/app_bottom_sheet.dart';

class PicImagePopup extends StatelessWidget {
  PicImagePopup(this._callBack, {super.key});

  final void Function(String) _callBack;
  final ImagePicker _picker = ImagePicker();

  static Future<void> show(
    BuildContext context,
    void Function(String path) onSelected,
  ) {
    return AppBottomSheet.show(
      context,
      title: 'Add Photo',
      subtitle: 'Choose how you want to upload the image',
      child: PicImagePopup(onSelected),
    );
  }

  Future<void> _onImageButtonPressed(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 600,
        maxHeight: 800,
      );
      _callBack(pickedFile?.path ?? '');
    } catch (_) {
      _callBack('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBottomSheetOption(
          icon: Icons.camera_alt_outlined,
          title: 'Take Photo',
          subtitle: 'Use device camera',
          onTap: () {
            Navigator.pop(context);
            _onImageButtonPressed(ImageSource.camera);
          },
        ),
        AppBottomSheetOption(
          icon: Icons.photo_library_outlined,
          title: 'Choose from Gallery',
          subtitle: 'Pick an existing photo',
          onTap: () {
            Navigator.pop(context);
            _onImageButtonPressed(ImageSource.gallery);
          },
        ),
      ],
    );
  }
}
