import 'package:camera/camera.dart';
import 'package:student_id/features/camera/domain/entities/camera_capture.dart';

class CameraScreenInput {
  final List<CameraDescription> cameras;
  final CameraCaptureInput subject;

  const CameraScreenInput(this.cameras, this.subject);
}
