/// Neutral input for the camera capture screen — no feature-specific entities.
class CameraCaptureInput {
  final String name;
  final String admissionNumber;

  const CameraCaptureInput({
    required this.name,
    required this.admissionNumber,
  });
}

/// Result returned after a photo is captured.
class CapturedPhoto {
  final String path;
  final CameraCaptureInput subject;

  const CapturedPhoto({
    required this.path,
    required this.subject,
  });
}
