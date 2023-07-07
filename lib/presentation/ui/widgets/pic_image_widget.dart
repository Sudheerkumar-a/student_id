import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PicImagePopup extends StatelessWidget {
  PicImagePopup(this._callBack, {super.key});
  final Function(String) _callBack;

  final ImagePicker _picker = ImagePicker();

  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
      );
      _callBack(pickedFile!.path);
    } catch (e) {
      _callBack('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const ListTile(
          title: Text(
            'Select Id Image By:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: const Text(
            'Camera',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          ),
          onTap: () {
            Navigator.pop(context);
            _onImageButtonPressed(ImageSource.camera, context: context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.photo_album),
          title: const Text(
            'Gallery',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          ),
          onTap: () {
            Navigator.pop(context);
            _onImageButtonPressed(ImageSource.gallery, context: context);
          },
        ),
      ],
    );
  }
}
