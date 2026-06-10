import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_id/features/camera/domain/entities/camera_capture.dart';
import 'package:student_id/features/camera/domain/entities/camera_screen_input.dart';
import 'package:student_id/shared/presentation/theme/form_tokens.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key});

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  final int _cameraType = 0;
  CameraScreenInput? _args;

  void _initializeCamera(List<CameraDescription> cameras) {
    _controller?.dispose();
    _controller = CameraController(
      cameras[_cameraType],
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller!.initialize();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller!.takePicture();
      if (!mounted || _args == null) return;

      await context.push(
        '/teacher-review',
        extra: CapturedPhoto(
          path: image.path,
          subject: _args!.subject,
        ),
      );
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra;
    if (extra is CameraScreenInput && _args != extra) {
      _args = extra;
      _initializeCamera(extra.cameras);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_args == null || _controller == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: const Text('Take Photo')),
        body: Center(
          child: CircularProgressIndicator(color: theme.colorScheme.onPrimary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Take Photo'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(FormTokens.spacingMd),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: FormTokens.spacingMd,
                    vertical: FormTokens.spacingSm,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(FormTokens.radiusMd),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: theme.colorScheme.primaryContainer,
                        size: 18,
                      ),
                      const SizedBox(width: FormTokens.spacingSm),
                      Expanded(
                        child: Text(
                          'Center your face in the frame with a plain background',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: FormTokens.spacingMd,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(FormTokens.radiusLg),
                    child: CameraPreview(_controller!),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  FormTokens.spacingMd,
                  FormTokens.spacingMd,
                  FormTokens.spacingMd,
                  FormTokens.spacingLg,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      Text(
                        'Tap to capture',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: FormTokens.spacingMd),
                      GestureDetector(
                        onTap: _takePicture,
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: theme.colorScheme.primary,
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
